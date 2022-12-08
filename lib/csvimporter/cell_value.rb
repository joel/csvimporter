# frozen_string_literal: true

module Csvimporter
  # This class get the cell value
  #
  # The column definition is called as follow:
  # column :my_method
  #
  # The method :my_method will be called onto the RowObject representation of the model
  # or onto the model itself by delegation.
  class CellValue
    attr_reader :action

    # Give the :method_name [Symbol]
    def initialize(action)
      @action = action
    end

    # Call the method through the RowObject or the Object by delegation.
    #
    # @param record [RowObject] Csv Row Representation of the Object
    #
    # @return [Object] the return of the method called
    def get_value(record)
      return record.public_send(action) if action.is_a?(Symbol)

      raise ArgumentError, "Unknown action [#{action}] for [#{action.class.name}]"
    end
  end
end
