# frozen_string_literal: true

shared_examples "with_or_without_csv_row_model_model" do |mod|
  context "without including Csvimporter::Model" do
    let(:klass) do
      Class.new do
        include mod

        column :string1
        column :string2
      end
    end

    it "works" do
      test_attributes
    end

    it "has Csvimporter::Model included" do
      module_indices = [mod, Csvimporter::Model].map { |c| klass.ancestors.index(c) }
      expect(module_indices).to eql module_indices.sort
    end
  end

  context "has Csvimporter::Model and another module" do
    let(:klass) do
      Class.new do
        include Csvimporter::Model
        include Csvimporter::Inspect
        include mod

        column :string1
        column :string2
      end
    end

    it "works" do
      test_attributes
    end

    it "class order is kept the same" do
      module_indices = [mod, Csvimporter::Inspect, Csvimporter::Model].map { |c| klass.ancestors.index(c) }
      expect(module_indices).to eql module_indices.sort
    end
  end
end
