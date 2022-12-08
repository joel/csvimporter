# frozen_string_literal: true

require "spec_helper"

describe Csvimporter::Import::FileModel do
  let(:context) { {} }

  describe "class" do
    let(:import_model_klass) { FileImportModel }

    describe "#header_matchers" do
      subject { import_model_klass.header_matchers(context) }

      let(:header_matchers) { [/^:: - string1 - ::$/i, /^:: - string2 - ::$/i] }

      it { expect(subject).to eql header_matchers }
    end

    describe "#index_header_match" do
      context "when is a match" do
        subject { import_model_klass.index_header_match(some_cell, context) }

        let(:some_cell) { ":: - string2 - ::" }

        it { expect(subject).to be 1 }
      end

      context "when is not a match" do
        subject { import_model_klass.index_header_match(some_cell, context) }

        let(:some_cell) { "String 3" }

        it { expect(subject).to be_nil }
      end
    end
  end
end
