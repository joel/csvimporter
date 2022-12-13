# frozen_string_literal: true

require "spec_helper"

module Csvimporter
  describe Import do
    it_behaves_like "with_or_without_csv_row_model_model", described_class
  end
end
