# frozen_string_literal: true

require "csvimporter/internal/attribute_base"

module Csvimporter
  module Import
    class Attribute < Csvimporter::AttributeBase
      attr_reader :source_value, :parsed_model_errors

      def initialize(column_name, source_value, parsed_model_errors, row_model)
        @source_value        = source_value
        @parsed_model_errors = parsed_model_errors

        super(column_name, row_model)
      end

      def value
        return if parsed_model_errors.present?

        @value ||= parsed_value
      end

      def parsed_value
        @parsed_value ||= formatted_value
      rescue StandardError
        nil
      end

    end
  end
end
