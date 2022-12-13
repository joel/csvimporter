# frozen_string_literal: true

require "spec_helper"

module Csvimporter
  module Import
    describe FileModel do
      let(:context) { {} }

      describe "class" do
        let(:import_model_klass) { FileImportModel }

        describe "#header_matchers" do
          subject(:header_matchers) { import_model_klass.header_matchers(context) }

          let(:expected_header_matchers) { [/^:: - string1 - ::$/i, /^:: - string2 - ::$/i] }

          it { expect(header_matchers).to eql expected_header_matchers }
        end

        describe "#index_header_match" do
          context "when is a match" do
            subject(:index_header_match) { import_model_klass.index_header_match(some_cell, context) }

            let(:some_cell) { ":: - string2 - ::" }

            it { expect(index_header_match).to be 1 }
          end

          context "when is not a match" do
            subject(:index_header_match) { import_model_klass.index_header_match(some_cell, context) }

            let(:some_cell) { "String 3" }

            it { expect(index_header_match).to be_nil }
          end
        end
      end
    end
  end
end
