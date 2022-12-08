# frozen_string_literal: true

module Csvimporter
  module Import
    class Representation
      attr_reader :name, :options, :row_model

      def initialize(name, options, row_model)
        @name = name
        @options = options
        @row_model = row_model
      end

      def value
        memoize? ? memoized_value : dependencies_value
      end

      def memoized_value
        @memoized_value ||= dependencies_value
      end

      def memoize?
        options.key?(:memoize) ? !!options[:memoize] : true
      end

      def dependencies_value
        valid_dependencies? ? lambda_value : empty_value
      end

      # @return [Boolean] if the dependencies are valid
      def valid_dependencies?
        dependencies.each { |attribute_name| return false if row_model.public_send(attribute_name).blank? }
        true
      end

      def empty_value
        options[:empty_value]
      end

      def lambda_value
        row_model.public_send(self.class.lambda_name(name))
      end

      def dependencies
        Array(options[:dependencies])
      end

      class << self
        def lambda_name(representation_name)
          :"__#{representation_name}"
        end

        def define_lambda_method(row_model_class, representation_name, &block)
          row_model_class.define_proxy_method(lambda_name(representation_name), &block)
        end

        def valid_options
          %i[memoize empty_value dependencies]
        end
      end
    end
  end
end
