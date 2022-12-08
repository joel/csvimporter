# frozen_string_literal: true

require "active_support/concern"
require "active_support/core_ext"

module Csvimporter
  module DynamicColumn
    DuplicateColumnDefinitionError = Class.new(StandardError)

    extend ActiveSupport::Concern

    included do
      class_attribute :dynamic_columns
    end

    class_methods do
      # DSL dynamic_column for dynamic_column definitions
      #
      # @param key_name [String] name of the Dynamic Header
      # @param options [Hash]
      #
      # @return [Hash] name of the dynamic_column
      def dynamic_column(key_name, options = {})
        self.dynamic_columns ||= {}

        if self.dynamic_columns.key?(key_name)
          raise DuplicateColumnDefinitionError, "Already defined column [#{key_name}]"
        end

        self.dynamic_columns = self.dynamic_columns.merge(
          key_name => options
        )
      end
    end
  end
end
