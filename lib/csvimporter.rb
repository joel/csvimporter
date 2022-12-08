# frozen_string_literal: true

require "csvimporter/version"

require "active_support"
require "active_support/dependencies/autoload"

require_relative "csvimporter/configure"

module Csvimporter
  extend Configure
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :DynamicColumn
    autoload :CellValue
    autoload :Configuration
    autoload :Column
    autoload :HeaderValue
    autoload :RowObject
    autoload :RowObjectType
    autoload :Exporter
    autoload :Filters
  end

  class Error < StandardError; end
end
