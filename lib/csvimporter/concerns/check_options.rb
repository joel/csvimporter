# frozen_string_literal: true

module Csvimporter
  module CheckOptions
    extend ActiveSupport::Concern

    class_methods do
      def check_options(*klasses)
        options = klasses.extract_options!
        valid_options = klasses.filter_map { |klass| klass.try(:valid_options) }.flatten

        invalid_options = options.keys - valid_options
        raise ArgumentError, "Invalid option(s): #{invalid_options}" if invalid_options.present?

        klasses.each { |klass| klass.try(:custom_check_options, options) }
        true
      end
    end
  end
end
