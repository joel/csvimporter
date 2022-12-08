# frozen_string_literal: true

module Csvimporter
  class RowObjectType
    attr_reader :source_model, :context

    def initialize(source_model:, context: {})
      @context = context
      @source_model = source_model
    end

    def row_object
      raise NotImplementedError
    end
  end
end
