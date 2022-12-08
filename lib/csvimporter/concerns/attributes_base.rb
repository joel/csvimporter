# frozen_string_literal: true

require "csvimporter/concerns/model/attributes"
require "csvimporter/concerns/hidden_module"

module Csvimporter
  module AttributesBase
    extend ActiveSupport::Concern
    include Model::Attributes
    include HiddenModule

    # @return [Hash] a map of `column_name => public_send(column_name)`
    def attributes
      attributes_from_method_names self.class.column_names
    end

    # Import:
    # source_value - form source_row
    # formatted_value - format_cell(source_value)
    # value - calculated_value from a bunch of stuff
    ATTRIBUTE_METHODS = {
      original_attributes: :value, # a map of `column_name => original_attribute(column_name)`
      formatted_attributes: :formatted_value, # a map of `column_name => format_cell(column_name, ...)`
      source_attributes: :source_value # a map of `column_name => source (source_row[index_of_column_name] or row_model.public_send(column_name)) `
    }.freeze
    ATTRIBUTE_METHODS.each do |method_name, attribute_method|
      define_method(method_name) do
        column_names_to_attribute_value(self.class.column_names, attribute_method)
      end
    end

    # @return [Object] the column's attribute (the csvimporter default value to be used for import)
    def original_attribute(column_name)
      attribute_objects[column_name].try(:value)
    end

    def to_json(*_args)
      attributes.to_json
    end

    def eql?(other)
      other.try(:attributes) == attributes
    end

    def hash
      attributes.hash
    end

    protected

    def attributes_from_method_names(column_names)
      array_to_block_hash(column_names) { |column_name| try(column_name) }
    end

    def column_names_to_attribute_value(column_names, attribute_method)
      array_to_block_hash(column_names) { |column_name| attribute_objects[column_name].public_send(attribute_method) }
    end

    def array_to_block_hash(array, &block)
      array.zip(array.map(&block)).to_h
    end

    class_methods do
      # See {Model#column}
      def column(column_name, options = {})
        super
        define_attribute_method(column_name)
      end

      # Define default attribute method for a column
      # @param column_name [Symbol] the cell's column_name
      def define_attribute_method(column_name, &block)
        return unless block

        return if method_defined? column_name

        define_proxy_method(column_name, &block)
      end

      def ensure_attribute_method
        column_names.each { |*args| define_attribute_method(*args) }
      end
    end
  end
end
