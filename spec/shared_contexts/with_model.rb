# frozen_string_literal: true

RSpec.shared_context "with model" do
  MyRowObject = Class.new(Csvimporter::RowObject) do
    def full_name
      "Sr. #{source_model.first_name} #{source_model.last_name}"
    end

    def trait(trait_name)
      return "YES" if source_model.traits.include?(trait_name)

      "NO"
    end
  end

  let(:row_object_type) do
    Class.new(Csvimporter::RowObjectType) do
      def row_object
        MyRowObject.new(source_model: source_model)
      end
    end
  end

  let(:model) do
    Class.new do
      def name
        "MyModel"
      end

      def first_name
        "John"
      end

      def last_name
        "Doe"
      end

      def traits
        %w[
          agreeableness
        ]
      end
    end
  end
end
