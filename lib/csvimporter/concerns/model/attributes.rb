# frozen_string_literal: true

require "inherited_class_var"
require "csvimporter/concerns/check_options"
require "csvimporter/internal/model/header"

module Csvimporter
  module Model
    module Attributes
      extend ActiveSupport::Concern
      include InheritedClassVar
      include CheckOptions

      included do
        inherited_class_hash :columns
      end

      def headers
        self.class.headers(context)
      end

      class_methods do
        # @return [Array<Symbol>] column names for the row model
        def column_names
          columns.keys
        end

        # @param [Symbol] column_name name of column to find index
        # @return [Integer] index of the column_name
        def index(column_name)
          column_names.index column_name
        end

        # @param [Hash, OpenStruct] context name of column to check
        # @return [Array] column headers for the row model
        def headers(context = {})
          column_names.map { |column_name| Header.new(column_name, self, context).value }
        end

        # Safe to override
        #
        # @return [String] formatted header
        def format_header(column_name, _context)
          column_name
        end

        # Safe to override. Method applied to each cell by default
        #
        # @param cell [String] the cell's string
        # @param column_name [Symbol] the cell's column_name
        def format_cell(cell, _column_name, _context)
          cell
        end

        #
        # Safe to override
        #
        # Really related to Import::Attributes, but placed here to help with the class heiarchy
        def class_to_parse_lambda
          Csvimporter::Import::Attributes::CLASS_TO_PARSE_LAMBDA
        end

        # Really related to Import::Attributes, but placed here to help with the class heiarchy (`::column` can be called without `include Csvimporter::Import`)
        def custom_check_options(options)
          return if options[:parse] || class_to_parse_lambda[options[:type]]

          raise ArgumentError, ":type must be #{class_to_parse_lambda.keys.compact.join(", ")}"
        end

        protected

        # Adds column to the row model
        #
        # @param [Symbol] column_name name of column to add
        # @param options [Hash]
        #
        # @option options [class] :type class you want to automatically parse to (by default does nothing, equivalent to String)
        # @option options [Lambda, Proc] :parse for parsing the cell
        # @option options [Boolean] :validate_type adds a validations within a {::parsed_model} call.
        # if true, it will add the default validation for the given :type (if applicable)
        #
        # @option options [Object] :default default value of the column if it is blank?, can pass Proc
        # @option options [String] :header human friendly string of the column name, by default format_header(column_name)
        # @option options [Hash] :header_matchs array with string to match cell to find in the row, by default column name
        def column(column_name, options = {})
          check_options Model::Header,
                        Import::ParsedModel::Model,
                        Import::Attribute,
                        self, # defined above
                        options

          columns_object.merge(column_name.to_sym => options)
        end

        def merge_options(column_name, options = {})
          column_name = column_name.to_sym
          column(column_name, options)
        end
      end
    end
  end
end
