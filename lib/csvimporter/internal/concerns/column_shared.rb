# frozen_string_literal: true

module Csvimporter
  module ColumnShared
    #
    # row_model
    #
    def context
      row_model.context
    end

    def options
      row_model_class.columns[column_name]
    end
  end
end
