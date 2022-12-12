# frozen_string_literal: true

require "csvimporter/concerns/attributes_base"
require "csvimporter/concerns/import/parsed_model"
require "csvimporter/internal/import/attribute"

module Csvimporter
  module Import
    module Attributes
      extend ActiveSupport::Concern
      include AttributesBase
      include ParsedModel

      included do
        ensure_attribute_method
      end

      def attribute_objects
        @attribute_objects ||= begin
          parsed_model.valid?
          _attribute_objects(parsed_model.errors)
        end
      end

      protected

      # to prevent circular dependency with parsed_model
      def _attribute_objects(parsed_model_errors = {})
        index = -1

        array_to_block_hash(self.class.column_names) do |column_name|

          sr = source_row[index += 1]


          Attribute.new(column_name, sr, parsed_model_errors[column_name], self)
        end
      end

      class_methods do

        protected

        def define_attribute_method(column_name)
          super { original_attribute(column_name) }
        end
      end

    end
  end
end
