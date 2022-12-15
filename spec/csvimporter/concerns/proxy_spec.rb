# frozen_string_literal: true

require "spec_helper"

module Csvimporter
  describe Proxy do
    let(:klass1)    { Class.new { include Csvimporter::Proxy } }
    let(:klass2)    { Class.new { include Csvimporter::Proxy } }
    let(:subclass1) { Class.new(klass1) }

    describe "class" do
      before { klass1.proxy }

      describe "included" do
        it "includes the hidden module in the class" do
          expect(klass1.included_modules.index(klass1.proxy)).to be 0
        end
      end

      describe "defining method" do
        subject(:new_method) { klass1.new.whatever }

        before { klass1.define_proxy_method(:whatever) { "in module" } }

        it do
          expect(new_method).to eql "in module"
        end
      end

      describe "::proxy" do
        subject(:proxy) { klass1.proxy }

        it "returns the module memoized" do
          expect(proxy.class).to eql Module
          expect(proxy.object_id).to eql klass1.proxy.object_id
          expect(proxy.object_id).not_to eql klass2.proxy.object_id
        end
      end
    end
  end
end
