# frozen_string_literal: true

require "active_support/concern"
require "active_support/core_ext"

module Csvimporter
  module Column
    DuplicateColumnDefinitionError = Class.new(StandardError)

    extend ActiveSupport::Concern

    included do
      class_attribute :columns
    end

    class_methods do
      # DSL column for column definitions
      #
      # column :name, header: 'First Name'
      #
      # @return [Hash] the column definition
      def column(method_name, options = { header: nil, column: nil, override: false })
        self.columns ||= {}

        if self.columns.key?(method_name) && !options[:override]
          raise DuplicateColumnDefinitionError, "Already defined column [#{method_name}], please use override: true"
        end

        self.columns = self.columns.merge(
          method_name => {
            header: options[:header] || method_name,
            column: options[:column] || method_name
          }
        )
      end
    end
  end
end
