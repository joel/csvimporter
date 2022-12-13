# frozen_string_literal: true

require "spec_helper"

module Csvimporter
  module Model
    describe Header do
      let(:instance) { described_class.new(:string1, row_model_class, string1: "context") }
      let(:row_model_class) do
        Class.new(BasicRowModel) do
          def self.format_header(*args)
            args.join("__")
          end
        end
      end

      describe "#value" do
        subject(:value) { instance.value }

        it "returns the formatted_header" do
          expect(value).to eql "string1__#<OpenStruct string1=\"context\">"
        end

        context "with :header option" do
          let(:row_model_class) do
            Class.new(BasicRowModel) do
              column :string1, header: "waka"
            end
          end

          it "returns the option value" do
            expect(value).to eql "waka"
          end
        end
      end
    end
  end
end
