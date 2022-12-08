# frozen_string_literal: true

RSpec.describe Csvimporter do
  it "delegates to the model" do
    expect(described_class::VERSION).to eql("0.3.5")
  end
end
