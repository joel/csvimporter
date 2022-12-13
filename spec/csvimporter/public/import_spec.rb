# frozen_string_literal: true

require "spec_helper"

module Csvimporter
  describe Import do
    def test_attributes
      expect(klass.new(%w[a b]).attributes).to eql(alpha: "a", beta: "b")
    end

    it_behaves_like "with_or_without_csv_row_model_model", described_class
  end
end
