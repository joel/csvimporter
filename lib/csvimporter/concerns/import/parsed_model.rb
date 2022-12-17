# frozen_string_literal: true

module Csvimporter
  module Import
    module ParsedModel
      extend ActiveSupport::Concern

      def valid?(*args)
        super

        parsed_model.valid?(*args)
        valid = errors.empty? && parsed_model.errors.empty?

        # Is ParserModel carry errors, we merge them to the RowModel
        errors.merge!(parsed_model.errors) unless parsed_model.errors.empty?

        # attribute_objects was called by valid? method, so we need to reset it to set the errors on the Attribute
        instance_variable_set(:@attribute_objects, nil) unless valid

        valid
      end

      def parsed_model
        @parsed_model ||= begin
          attribute_objects = _attribute_objects
          formatted_hash = array_to_block_hash(self.class.column_names) do |column_name|
            attribute_objects[column_name].formatted_value
          end
          self.class.parsed_model_class.new(formatted_hash)
        end
      end

      class_methods do
        def parsed_model_class
          @parsed_model_class ||= Model
        end

        protected

        def parsed_model(&block)
          parsed_model_class.class_eval(&block)
        end
      end

      class Model < OpenStruct
        include ActiveModel::Validations
      end
    end
  end
end
