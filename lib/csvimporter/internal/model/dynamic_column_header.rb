# frozen_string_literal: true

require "csvimporter/internal/model/header"
require "csvimporter/internal/concerns/dynamic_column_shared"

module Csvimporter
  module Model
    class DynamicColumnHeader < Header
      include DynamicColumnShared

      def value
        header_models.map { |header_model| header_proc.call(header_model) }
      end

      def header_proc
        options[:header] || ->(header_model) { format_header(header_model) }
      end

      def format_header(header_model)
        row_model_class.format_dynamic_column_header(header_model, column_name, context)
      end
    end
  end
end
