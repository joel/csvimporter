# frozen_string_literal: true

require "csvimporter/internal/concerns/column_shared"

module Csvimporter
  module Model
    class Header
      include ColumnShared

      attr_reader :column_name, :row_model_class, :context

      def initialize(column_name, row_model_class, context)
        @column_name     = column_name
        @row_model_class = row_model_class
        @context         = OpenStruct.new(context)
      end

      def value
        options[:header] || formatted_header
      end

      def formatted_header
        row_model_class.format_header(column_name, context)
      end
    end
  end
end
