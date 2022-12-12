# frozen_string_literal: true

require "csvimporter/internal/concerns/column_shared"

module Csvimporter
  class AttributeBase
    include ColumnShared

    attr_reader :column_name, :row_model

    def initialize(column_name, row_model)
      @column_name = column_name
      @row_model   = row_model
    end

    def formatted_value
      @formatted_value ||= row_model_class.format_cell(source_value, column_name, row_model.context)
    end

    def row_model_class
      row_model.class
    end
  end
end
