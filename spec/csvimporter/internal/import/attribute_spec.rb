# frozen_string_literal: true

require "spec_helper"

module Csvimporter
  module Import
    describe Attribute do
      describe "instance" do
        let(:parsed_model_errors) { nil }
        let(:row_model_class)     { Class.new BasicImportModel }
        let(:source_value)        { "alpha" }
        let(:source_row)          { [source_value, "original_beta"] }
        let(:row_model)           { row_model_class.new(source_row) }
        let(:options)             { {} }
        let(:instance)            { described_class.new(:alpha, source_value, parsed_model_errors, row_model) }

        it_behaves_like "has_needed_value_methods"

        describe "#value" do
          subject(:value) { instance.value }

          it "memoizes the result" do
            expect(value).to eql "alpha"
            expect(value.object_id).to eql instance.value.object_id
          end

          it "calls format_cell and returns the result" do
            allow(instance).to receive(:formatted_value).once.and_return("whatever")
            expect(value).to eql("whatever")
          end

          context "with empty parsed_model_errors" do
            let(:parsed_model_errors) { [] }

            it "returns the result" do
              expect(value).to eql("alpha")
            end
          end
        end

        describe "#parsed_value" do
          subject(:parsed_value) { instance.parsed_value }

          it "memoizes the result" do
            expect(parsed_value).to eql "alpha"
            expect(parsed_value.object_id).to eql instance.value.object_id
          end
        end
      end
    end
  end
end
