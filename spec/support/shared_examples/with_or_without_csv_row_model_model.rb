# frozen_string_literal: true

shared_examples "with_or_without_csv_row_model_model" do |mod|
  context "without including Csvimporter::Model" do
    let(:klass) do
      Class.new do
        include mod

        column :alpha
        column :beta
      end
    end

    it do
      expect(klass.new(%w[alpha beta]).attributes).to eql(alpha: "alpha", beta: "beta")
    end

    it "has Csvimporter::Model included" do
      module_indices = [mod, Csvimporter::Model].map { |c| klass.ancestors.index(c) }
      expect(module_indices).to eql module_indices.sort
    end
  end

  context "when has Csvimporter::Model and another module" do
    let(:klass) do
      Class.new do
        include Csvimporter::Model
        include mod

        column :alpha
        column :beta
      end
    end

    it do
      expect(klass.new(%w[alpha beta]).attributes).to eql(alpha: "alpha", beta: "beta")
    end

    it "class order is kept the same" do
      module_indices = [mod, Csvimporter::Model].map { |c| klass.ancestors.index(c) }
      expect(module_indices).to eql module_indices.sort
    end
  end
end
