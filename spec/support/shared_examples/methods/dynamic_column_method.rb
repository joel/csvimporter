# frozen_string_literal: true

shared_examples "dynamic_column_method" do |mod, expectation|
  context "when module included before and after #column call" do
    subject { row_model_class.send(:dynamic_column, :skills) }

    let(:row_model_class) do
      klass = Class.new { include Csvimporter::Model }
      klass.send(:include, mod)
    end

    it "calls the right method and defines the method" do
      expect(row_model_class).to receive(:define_dynamic_attribute_method).with(:skills).and_call_original
      subject
      expect(instance.skills).to eql(expectation)
    end

    context "when defined before module" do
      let(:row_model_class) do
        klass = Class.new { include Csvimporter::Model }
        klass.send(:dynamic_column, :skills)
        klass.send(:include, mod)
      end

      it "works" do
        expect(instance.skills).to eql(expectation)
      end
    end
  end
end
