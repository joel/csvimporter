# frozen_string_literal: true

require "spec_helper"

module Csvimporter
  describe AttributeBase do
    describe "instance" do
      let(:instance)        { described_class.new(:alpha, row_model) }
      let(:row_model_class) { Class.new BasicRowModel }
      let(:row_model)       { row_model_class.new }

      let(:source_value) { "alpha one" }

      before do
        allow(instance).to receive(:source_value).once.and_return(source_value)
      end

      describe "#formatted_value" do
        subject(:formatted_value) { instance.formatted_value }

        before do
          row_model_class.class_eval do
            def self.format_cell(*args)
              args[0..1].join(" - ")
            end
          end
        end

        it "returns the formatted_cell value and memoizes it" do
          expect(formatted_value).to eql("alpha one - alpha")
          expect(formatted_value.object_id).to eql instance.formatted_value.object_id
        end
      end
    end
  end
end
