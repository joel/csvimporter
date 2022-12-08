# frozen_string_literal: true

require "active_support/core_ext"

module Csvimporter
  class RowObject
    attr_reader :source_model, :context

    def initialize(source_model:, context: {})
      @context = context
      @source_model = source_model
    end

    def row_object
      self
    end

    delegate_missing_to :source_model
  end
end
