# frozen_string_literal: true

require "spec_helper"

module Csvimporter
  module Model
    describe Attributes do
      describe "class" do
        let(:klass) { BasicRowModel }

        describe "::column_names" do
          subject(:column_names) { klass.column_names }

          specify { expect(column_names).to eql %i[alpha beta] }
        end

        describe "::format_header" do
          subject(:format_header) { BasicRowModel.format_header(header, nil) }

          let(:header) { "user_name" }

          it "returns the header" do
            expect(format_header).to eql header
          end
        end

        describe "::headers" do
          subject(:row_model_headers) { klass.headers }

          let(:headers) { [:alpha, "Beta Two"] }

          it "returns an array with header column names" do
            expect(row_model_headers).to eql headers
          end
        end

        describe "::format_cell" do
          subject(:format_cell) { BasicRowModel.format_cell(cell, nil, nil) }

          let(:cell) { "the_cell" }

          it "returns the cell" do
            expect(format_cell).to eql cell
          end
        end
      end
    end
  end
end
