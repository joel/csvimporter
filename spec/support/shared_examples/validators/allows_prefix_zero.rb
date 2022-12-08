# frozen_string_literal: true

shared_examples "allows_prefix_zero" do
  context "with prefix zero" do
    before { instance.string1 = "0000#{instance.string1}" }

    it "is valid" do
      expect(subject).to be true
    end
  end
end
