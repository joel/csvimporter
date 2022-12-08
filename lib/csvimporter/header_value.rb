# frozen_string_literal: true

module Csvimporter
  # This class get the header value
  #
  # The column definition is called as follow:
  # column :my_method, header: 'My method'
  #
  # If there is no header definition a String representation of the key is returned
  #
  # If a proc is passed, it will be executed in the context of the RowObject
  # e.g: column :original_risk_score, header: proc { "Original #{parent_in_hierarchy.score_label}" }
  class HeaderValue
    InconsistentValueError = Class.new(StandardError)

    attr_reader :action

    # Give the header name [Nil|String|Symbol|Proc]
    def initialize(action)
      @action = action
    end

    # Return the header value
    #
    # @param record [RowObject] Csv Row Representation of the Object
    #
    # @return [String] the return the header name
    def get_value(record = nil)
      return "No Header Passed" unless action

      case action
      when String
        action
      when Symbol
        action.to_s.tr("_", " ").humanize
      when Proc
        if record.nil?
          raise InconsistentValueError,
                "You must provide an object with lambda, " \
                "MyExporter.<headers|content|generate>(collection, context: { record: MyModel.new }})"
        end
        record.instance_exec(&action)
      else
        raise ArgumentError, "Unknown action [#{action}] for [#{action.class.name}]"
      end
    end
  end
end
