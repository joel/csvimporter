# frozen_string_literal: true

shared_examples "allows_suffix_zero" do
  context "with suffix zero" do
    before { instance.string1 += "0000" }

    it "is valid" do
      expect(subject).to be true
    end
  end
end
