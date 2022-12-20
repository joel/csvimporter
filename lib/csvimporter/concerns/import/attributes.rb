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
        @attribute_objects ||= _attribute_objects
      end

      def read_attribute_for_validation(attr)
        source_row[self.class.column_names.index(attr)]
      end

      protected

      def _attribute_objects
        index = -1

        array_to_block_hash(self.class.column_names) do |column_name|
          Attribute.new(column_name, source_row[index += 1], errors.to_hash[column_name], self)
        end
      end

      class_methods do
        def define_attribute_method(column_name)
          return if super { original_attribute(column_name) }.nil?
        end
      end
    end
  end
end
