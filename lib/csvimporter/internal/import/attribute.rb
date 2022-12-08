# frozen_string_literal: true

require "csvimporter/internal/attribute_base"

module Csvimporter
  module Import
    class Attribute < Csvimporter::AttributeBase
      attr_reader :source_value, :parsed_model_errors

      def initialize(column_name, source_value, parsed_model_errors, row_model)
        @source_value = source_value
        @parsed_model_errors = parsed_model_errors
        super(column_name, row_model)
      end

      def value
        @value ||= begin
          return unless parsed_model_errors.blank?

          default? ? default_value : parsed_value
        end
      end

      def parsed_value
        @parsed_value ||= begin
          value = formatted_value
          value.present? ? row_model.instance_exec(formatted_value, &parse_lambda) : value
        end
      rescue StandardError
        nil
      end

      def default_value
        @default_value ||= begin
          default = options[:default]
          default.is_a?(Proc) ? row_model.instance_exec(&default) : default
        end
      end

      def default?
        options.key?(:default) && parsed_value.blank?
      end

      def default_change
        [formatted_value, default_value] if default?
      end

      protected

      # @return [Lambda, Proc] returns the Lambda/Proc given in the parse option or the one given by `row_model_class.class_to_parse_lambda`
      def parse_lambda
        options[:parse] || row_model_class.class_to_parse_lambda[options[:type]]
      end

      class << self
        def custom_check_options(options)
          raise ArgumentError, "Use :parse OR :type option, but not both" if options[:parse] && options[:type]
        end

        def valid_options
          %i[type parse default]
        end
      end
    end
  end
end
