# frozen_string_literal: true

require "csvimporter/concerns/attributes_base"
require "csvimporter/internal/import/attribute"

module Csvimporter
  module Import
    module Attributes
      extend ActiveSupport::Concern
      include AttributesBase

      included do
        ensure_attribute_method
      end

      def attribute_objects
        @attribute_objects ||= _attribute_objects
      end

      def parsed_model
        @parsed_model ||= begin
          formatted_hash = array_to_block_hash(self.class.column_names) { |column_name| attribute_objects[column_name].formatted_value }
          self.class.new(formatted_hash.values)
        end
      end

      protected

      def _attribute_objects(attributes_errors = {})
        index = -1

        array_to_block_hash(self.class.column_names) do |column_name|
          Attribute.new(column_name, source_row[index += 1], attributes_errors[column_name], self)
        end
      end

      class_methods do

        protected

        def define_attribute_method(column_name)
          super { original_attribute(column_name) }
        end

        def parsed_model_class
          @parsed_model_class ||= self
        end

        def parsed_model(&block)
          parsed_model_class.class_eval(&block)
        end

      end

    end
  end
end
