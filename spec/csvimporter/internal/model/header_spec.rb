# frozen_string_literal: true

require "spec_helper"

module Csvimporter
  module Model
    describe Header do
      let(:instance) { described_class.new(:alpha, row_model_class, alpha: "context") }
      let(:row_model_class) do
        Class.new(BasicRowModel) do
          def self.format_header(*args)
            args.join(" - ")
          end
        end
      end

      describe "#value" do
        subject(:value) { instance.value }

        it "returns the formatted_header" do
          expect(value).to eql "alpha - #<OpenStruct alpha=\"context\">"
        end

        context "with :header option" do
          let(:row_model_class) do
            Class.new(BasicRowModel) do
              column :alpha, header: "Alpha Thor"
            end
          end

          it "returns the option value" do
            expect(value).to eql "Alpha Thor"
          end
        end
      end
    end
  end
end
