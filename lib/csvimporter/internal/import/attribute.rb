# frozen_string_literal: true

require "csvimporter/internal/attribute_base"

module Csvimporter
  module Import
    class Attribute < Csvimporter::AttributeBase
      attr_reader :source_value, :attribute_errors

      def initialize(column_name, source_value, attribute_errors, row_model)
        @source_value     = source_value
        @attribute_errors = attribute_errors

        super(column_name, row_model)
      end

      def value
        @value ||= begin
          if attribute_errors.present?
            nil
          else
            formatted_value
          end
        end
      end

    end
  end
end
