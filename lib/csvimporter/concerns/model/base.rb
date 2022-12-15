# frozen_string_literal: true

module Csvimporter
  module Model
    module Base
      extend ActiveSupport::Concern

      included do
        attr_reader :context, :initialized_at
      end

      # @param [Hash] options
      # @option options [Hash] :context extra data you want to work with the model
      def initialize(options = {})
        @initialized_at = DateTime.now
        @context        = OpenStruct.new(options[:context] || {})
      end
    end
  end
end
