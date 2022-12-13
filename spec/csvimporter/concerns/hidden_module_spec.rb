# frozen_string_literal: true

require "spec_helper"

module Csvimporter
  describe HiddenModule do
    let(:klass1)    { Class.new { include Csvimporter::HiddenModule } }
    let(:klass2)    { Class.new { include Csvimporter::HiddenModule } }
    let(:subclass1) { Class.new(klass1) }

    describe "class" do
      before { klass1.hidden_module }

      describe "included" do
        it "includes the hidden module in the class" do
          expect(klass1.included_modules.index(klass1.hidden_module)).to be 0
        end
      end

      describe "defining method" do
        subject(:new_method) { klass1.new.waka }

        before { klass1.define_proxy_method(:waka) { "in module" } }

        it do
          expect(new_method).to eql "in module"
        end
      end

      describe "::hidden_module" do
        subject(:hidden_module) { klass1.hidden_module }

        it "returns the module memoized" do
          expect(hidden_module.class).to eql Module
          expect(hidden_module.object_id).to eql klass1.hidden_module.object_id
          expect(hidden_module.object_id).not_to eql klass2.hidden_module.object_id
        end
      end
    end
  end
end
