# frozen_string_literal: true

module Csvimporter
  module Import
    module ParsedModel
      extend ActiveSupport::Concern

      # @return [Import::ParsedModel::Model] a model with validations related to parsed_model (values are from format_cell)
      def parsed_model
        @parsed_model ||= begin
          attribute_objects = _attribute_objects
          formatted_hash = array_to_block_hash(self.class.column_names) do |column_name|
            attribute_objects[column_name].formatted_value
          end
          self.class.parsed_model_class.new(formatted_hash)
        end
      end

      protected

      def _original_attribute(column_name)
        parsed_model.valid?
        return nil unless parsed_model.errors[column_name].blank?
      end

      class_methods do
        # @return [Class] the Class with validations of the parsed_model
        def parsed_model_class
          @parsed_model_class ||= self
        end

        # Called to add validations to the parsed_model_class
        def parsed_model(&block)
          parsed_model_class.class_eval(&block)
        end
      end
    end
  end
end
