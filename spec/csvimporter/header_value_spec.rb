# frozen_string_literal: true

module Csvimporter
  RSpec.describe HeaderValue do
    include_context "with model"

    it "returnses [No Header Passed] when no header given" do
      expect(described_class.new(nil).get_value(model.new)).to eql("No Header Passed")
    end

    it "returnses the header without change if String given" do
      expect(described_class.new("Do Not Change Me").get_value).to eql("Do Not Change Me")
    end

    it "returnses [No Record Given] if no record passed with Proc" do
      expect do
        described_class.new(-> { "Hi #{first_name}" }).get_value
      end.to raise_error(HeaderValue::InconsistentValueError,
                         "You must provide an object with lambda, " \
                         "MyExporter.<headers|content|generate>(collection, context: { record: MyModel.new }})")
    end

    it "executes the proc in the object context" do
      expect(described_class.new(-> { "We are #{count}" }).get_value([1, 2, 3])).to eql("We are 3")
    end
  end
end
