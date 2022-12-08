# frozen_string_literal: true

require "csvimporter/internal/import/representation"

module Csvimporter
  module Import
    module Represents
      extend ActiveSupport::Concern

      included do
        inherited_class_hash :representations
      end

      def representation_objects
        @representation_objects ||= array_to_block_hash(self.class.representation_names) do |representation_name|
          Representation.new(representation_name, self.class.representations[representation_name], self)
        end
      end

      def representation_value(representation_name)
        representation_objects[representation_name].try(:value)
      end

      def representations
        attributes_from_method_names(self.class.representation_names)
      end

      def all_attributes
        attributes.merge!(representations)
      end

      def valid?(*args)
        super
        filter_errors
        errors.empty?
      end

      protected

      # remove each dependent attribute from errors if it's representation dependencies are in the errors
      def filter_errors
        self.class.representation_names.each do |representation_name|
          next unless errors.messages.slice(*representation_objects[representation_name].dependencies).present?

          errors.delete representation_name
        end
      end

      class_methods do
        # @return [Array<Symbol>] names of all representations
        def representation_names
          representations.keys
        end

        # Defines a representation for singular resources
        #
        # @param [Symbol] representation_name name of representation to add
        # @param [Proc] block to define the attribute
        # @param options [Hash]
        # @option options [Hash] :memoize whether to memoize the attribute (default: true)
        # @option options [Hash] :dependencies the dependencies with other attributes/representations (default: [])
        def represents_one(...)
          define_representation_method(...)
        end

        # Defines a representation for multiple resources
        #
        # @param [Symbol] representation_name name of representation to add
        # @param [Proc] block to define the attribute
        # @param options [Hash]
        # @option options [Hash] :memoize whether to memoize the attribute (default: true)
        # @option options [Hash] :dependencies the dependencies with other attributes/representations (default: [])
        def represents_many(representation_name, options = {}, &block)
          define_representation_method(representation_name, options.merge(empty_value: []), &block)
        end

        def define_representation_method(representation_name, options = {}, &block)
          representations_object.merge(representation_name.to_sym => options)
          define_proxy_method(representation_name) { representation_value(representation_name) }
          Representation.define_lambda_method(self, representation_name, &block)
        end
      end
    end
  end
end
