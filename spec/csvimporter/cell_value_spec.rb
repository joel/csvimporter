# frozen_string_literal: true

module Csvimporter
  RSpec.describe CellValue do
    subject(:instance) do
      described_class.new(:first_name)
    end

    include_context "with model"

    it "calls method onto the model" do
      expect(instance.get_value(model.new)).to eql("John")
    end

    it "throws an error" do
      expect do
        described_class.new("unknown").get_value(model.new)
      end.to raise_error(ArgumentError), "Unknown action [unknown] for [String]"
    end
  end
end
