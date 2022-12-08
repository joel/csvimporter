# frozen_string_literal: true

require "csvimporter/public/model"
require "csvimporter/concerns/import/base"
require "csvimporter/concerns/import/attributes"
require "csvimporter/concerns/import/represents"

module Csvimporter
  # Include this to with {Model} to have a RowModel for importing csvs.
  module Import
    extend ActiveSupport::Concern

    include Csvimporter::Model

    include Base
    include Attributes
    include Represents
  end
end
