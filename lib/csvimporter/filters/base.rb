# frozen_string_literal: true

module Csvimporter
  module Filters
    class Base
      attr_reader :headers

      # Give the :method_name [Symbol]
      def initialize(headers:, headers_to_filter:)
        @headers = headers
        @headers_to_filter = headers_to_filter
      end

      protected

      attr_reader :headers_to_filter
    end
  end
end
