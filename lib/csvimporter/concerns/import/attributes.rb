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

      # return [Hash] a map changes from {.column}'s default option': `column_name -> [value_before_default, default_set]`
      def default_changes
        column_names_to_attribute_value(self.class.column_names, :default_change).delete_if { |_k, v| v.blank? }
      end

      protected

      # to prevent circular dependency with parsed_model
      def _attribute_objects(parsed_model_errors = {})
        index = -1
        array_to_block_hash(self.class.column_names) do |column_name|
          Attribute.new(column_name, source_row[index += 1], parsed_model_errors[column_name], self)
        end
      end
    end
  end
end
