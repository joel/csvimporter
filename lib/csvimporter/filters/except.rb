# frozen_string_literal: true

module Csvimporter
  module Filters
    class Except < Base
      def filtered_headers
        @filtered_headers ||= headers.reject { |header| headers_to_filter.include?(header) }
      end

      def filtered_cells(values)
        duplicate_values = values.dup
        filtered_column_indexes.each { |index| duplicate_values.delete_at(index) }
        duplicate_values
      end

      private

      def filtered_column_indexes
        @filtered_column_indexes ||= headers_to_filter.map do |except_header|
          headers.index(except_header)
        end
      end
    end
  end
end
