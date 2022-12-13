# frozen_string_literal: true

require "spec_helper"

module Csvimporter
  module Import
    describe Attribute do
      describe "instance" do
        let(:parsed_model_errors) { nil }
        let(:row_model_class)     { Class.new BasicImportModel }
        let(:source_value)        { "1.01" }
        let(:source_row)          { [source_value, "original_string2"] }
        let(:row_model)           { row_model_class.new(source_row) }
        let(:options)             { {} }
        let(:instance)            { described_class.new(:string1, source_value, parsed_model_errors, row_model) }

        it_behaves_like "has_needed_value_methods"

        describe "#value" do
          subject(:value) { instance.value }

          it "memoizes the result" do
            expect(value).to eql "1.01"
            expect(value.object_id).to eql instance.value.object_id
          end

          it "calls format_cell and returns the result" do
            allow(instance).to receive(:formatted_value).and_return("waka")
            expect(value).to eql("waka")
          end

          context "with empty parsed_model_errors" do
            let(:parsed_model_errors) { [] }

            it "returns the result" do
              expect(value).to eql("1.01")
            end
          end
        end

        describe "#parsed_value" do
          subject(:parsed_value) { instance.parsed_value }

          it "memoizes the result" do
            expect(parsed_value).to eql "1.01"
            expect(parsed_value.object_id).to eql instance.value.object_id
          end
        end
      end
    end
  end
end
