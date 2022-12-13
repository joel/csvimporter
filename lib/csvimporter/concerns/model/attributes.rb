# frozen_string_literal: true

require "csvimporter/internal/model/header"

module Csvimporter
  module Model
    module Attributes
      extend ActiveSupport::Concern

      included do
        mattr_accessor :_columns, instance_writer: false, instance_reader: false
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

        def columns
          self._columns ||= {}
        end

        protected

        # Adds column to the row model
        #
        # @param [Symbol] column_name name of column to add
        # @param options [Hash]
        #
        # @option options [String] :header header for the column
        def column(column_name, options = {})
          self._columns = self.columns.merge(column_name.to_sym => options)
        end

      end
    end
  end
end
