# frozen_string_literal: true

require "spec_helper"

describe Csvimporter::Model::Attributes do
  describe "class" do
    let(:klass) { BasicRowModel }

    describe "::column_names" do
      subject { klass.column_names }

      specify { expect(subject).to eql %i[string1 string2] }
    end

    describe "::format_header" do
      subject { BasicRowModel.format_header(header, nil) }

      let(:header) { "user_name" }

      it "returns the header" do
        expect(subject).to eql header
      end
    end

    describe "::headers" do
      subject { klass.headers }

      let(:headers) { [:string1, "String 2"] }

      it "returns an array with header column names" do
        expect(subject).to eql headers
      end
    end

    describe "::format_cell" do
      subject { BasicRowModel.format_cell(cell, nil, nil) }

      let(:cell) { "the_cell" }

      it "returns the cell" do
        expect(subject).to eql cell
      end
    end
  end
end
