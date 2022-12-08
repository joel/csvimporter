# frozen_string_literal: true

module Csvimporter
  module Filters
    class Only < Base
      def filtered_headers
        @filtered_headers ||= headers.select { |header| headers_to_filter.include?(header) }
      end

      def filtered_cells(values)
        filtered_column_indexes.map do |index|
          values[index]
        end
      end

      private

      def filtered_column_indexes
        @filtered_column_indexes ||= headers_to_filter.map do |only_header|
          headers.index(only_header)
        end
      end
    end
  end
end
