# frozen_string_literal: true

require "active_support/concern"
require "ostruct"
require "structured_warnings"

module Csvimporter
  module Exporter
    extend ActiveSupport::Concern

    included do
      attr_reader :collection, :csv_options, :context, :row_object_type
    end

    def initialize(collection, row_object_type, options = {})
      @row_object_type = row_object_type
      @context = OpenStruct.new(options[:context] || {})
      warn StructuredWarnings::StandardWarning, "No context provided" unless options.key(:context)
      @collection = collection
      @csv_options = default_options.merge(options.except(:context))
    end

    class_methods do
      # Generate the CSV output from the rows collection
      #
      # MyExporter.content(collection, options)
      #
      # @return [String] the CSV output string
      def content(collection, row_object_type, options = {})
        instance = new(collection, row_object_type, options)
        instance.content
      end

      def generate(collection, row_object_type, options = {})
        instance = new(collection, row_object_type, options)
        instance.generate
      end

      def headers(collection = nil, row_object_type = nil, options = {})
        instance = new(collection, row_object_type, options)
        instance.headers
      end
    end

    # Generate the CSV output from the rows collection
    #
    # Iterate over the collection to transform model instance into CSV row format
    #
    # @return [String] the CSV output string
    def raw_content
      collection.inject([]) do |result, entry|
        values = column_definitions.map do |_, column_definition|
          wrap_column(
            column_definition[:column]
          ).get_value(
            row_object(entry)
          ).presence
        end

        add_dynamic_values(entry) { values }

        result << values
      end
    end

    def content
      raw_content.map do |row|
        filter.filtered_cells(row)
      end
    end

    def generate
      csv_engine.generate(**csv_options) do |csv|
        content.each do |entry|
          csv << entry
        end
      end
    end

    def raw_headers
      @raw_headers ||= begin
        raw_headers = column_definitions.map do |_, column_definition|
          wrap_header(
            column_definition[:header]
          ).get_value(row_object(context.to_h.fetch(:record, nil)))
        end
        raw_headers += dynamic_headers if dynamic_columns?
        raw_headers
      end
    end

    def headers
      @headers ||= filter.filtered_headers
    end

    private

    def filter
      @filter ||= filter_class.new(headers: raw_headers, headers_to_filter: headers_to_filter)
    end

    def filter_class
      return Filters::Except if context.except
      return Filters::Only if context.only

      Filters::None
    end

    def headers_to_filter
      raise ":only and :except headers are mutually exclusive" if context.except.present? && context.only.present?
      return context.except if context.except
      return context.only if context.only

      []
    end

    def wrap_header(header)
      HeaderValue.new(header)
    end

    def wrap_column(column)
      CellValue.new(column)
    end

    def row_object(current_record)
      return unless current_record
      return current_record.row_object(context) if current_record.respond_to?(:row_object)

      raise "No Row Object Type Given" unless row_object_type

      row_object_type.new(source_model: current_record, context: context).row_object
    end

    def default_options
      {
        headers: headers,
        write_headers: true
      }
    end

    def dynamic_headers
      return [] unless context

      self.class.dynamic_columns.keys.flat_map do |key_name|
        next unless context[key_name]

        context[key_name].map(&:humanize)
      end.compact
    end

    def add_dynamic_values(static_record)
      return if context.to_h.empty?
      return unless dynamic_columns?

      self.class.dynamic_columns.each_key do |key_name|
        context.to_h.fetch(key_name, [])&.each do |header_value|
          csv_row_object = row_object(static_record)
          yield << csv_row_object.public_send(key_name.to_s.singularize, header_value)
        end
      end
    end

    def dynamic_columns?
      defined?(DynamicColumn) && self.class.included_modules.include?(DynamicColumn)
    end

    def column_definitions
      self.class.columns
    end

    def csv_engine
      Csvimporter.configuration.csv_engine
    end
  end
end
