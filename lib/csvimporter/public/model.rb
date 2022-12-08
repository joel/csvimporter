# frozen_string_literal: true

require "csvimporter/concerns/model/base"
require "csvimporter/concerns/model/attributes"
require "csvimporter/concerns/model/dynamic_columns"

module Csvimporter
  # Base module for representing a RowModel---a model that represents row(s).
  module Model
    extend ActiveSupport::Concern

    include ActiveWarnings

    include Base
    include Attributes
    include DynamicColumns
  end
end
