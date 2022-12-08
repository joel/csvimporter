# frozen_string_literal: true

require "spec_helper"

describe Csvimporter::HiddenModule do
  let(:klass1) { Class.new { include Csvimporter::HiddenModule } }
  let(:klass2) { Class.new { include Csvimporter::HiddenModule } }
  let(:subclass1) { Class.new(klass1) }

  describe "class" do
    before { klass1.hidden_module }

    describe "included" do
      it "includes the hidden module in the class" do
        expect(klass1.included_modules.index(klass1.hidden_module)).to be 0
      end
    end

    describe "defining method" do
      subject { klass1.new.waka }

      before { klass1.define_proxy_method(:waka) { "in module" } }

      it "works" do
        expect(subject).to eql "in module"
      end

      context "with super method defined" do
        let(:klass1) do
          Class.new do
            include Csvimporter::HiddenModule
          end
        end

        it "can call super" do
          expect(subject).to eql "in module"
        end
      end
    end

    describe "::hidden_module" do
      subject { klass1.hidden_module }

      it "returns the module memoized" do
        expect(subject.class).to eql Module
        expect(subject.object_id).to eql klass1.hidden_module.object_id
        expect(subject.object_id).not_to eql klass2.hidden_module.object_id
      end
    end
  end
end
