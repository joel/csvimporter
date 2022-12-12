# frozen_string_literal: true

require "csvimporter/public/model"
require "csvimporter/concerns/import/base"
require "csvimporter/concerns/import/attributes"

module Csvimporter
  # Include this to with {Model} to have a RowModel for importing csvs.
  module Import
    extend ActiveSupport::Concern

    include Csvimporter::Model

    include ActiveModel::Validations

    include Base
    include Attributes
  end
end
