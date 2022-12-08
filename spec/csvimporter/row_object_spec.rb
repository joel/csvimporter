# frozen_string_literal: true

module Csvimporter
  RSpec.describe RowObject do
    subject(:instance) do
      described_class.new(source_model: model.new)
    end

    let(:model) do
      Class.new do
        def name
          "MyModel"
        end

        def first_name
          "John"
        end
      end
    end

    it "delegates to the model" do
      expect(instance.first_name).to eql("John")
    end
  end
end
