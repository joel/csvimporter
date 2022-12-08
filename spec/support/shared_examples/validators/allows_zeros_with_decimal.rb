# frozen_string_literal: true

shared_examples "allows_zeros_with_decimal" do
  context "with 0.0" do
    before { instance.string1 = "0.0" }

    it "is valid" do
      expect(subject).to be true
    end
  end

  context "with 000.0000" do
    before { instance.string1 = "000.0000" }

    it "is valid" do
      expect(subject).to be true
    end
  end

  context "with abc000.0000abc" do
    before { instance.string1 = "abc000.0000abc" }

    it "is invalid" do
      expect(subject).to be false
    end
  end

  context "with a000b.c0000d" do
    before { instance.string1 = "a000b.c0000d" }

    it "is invalid" do
      expect(subject).to be false
    end
  end
end
