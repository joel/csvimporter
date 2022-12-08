# frozen_string_literal: true

require "spec_helper"

describe Csvimporter::Import do
  def test_attributes
    expect(klass.new(%w[a b]).attributes).to eql(string1: "a", string2: "b")
  end

  it_behaves_like "with_or_without_csv_row_model_model", described_class
end
