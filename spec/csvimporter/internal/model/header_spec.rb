# frozen_string_literal: true

require "spec_helper"

module Csvimporter
  module Model
    describe Header do
      let(:instance) { described_class.new(:alpha, row_model_class, alpha: "context") }
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
          expect(value).to eql "alpha__#<OpenStruct alpha=\"context\">"
        end

        context "with :header option" do
          let(:row_model_class) do
            Class.new(BasicRowModel) do
              column :alpha, header: "waka"
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
