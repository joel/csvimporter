# frozen_string_literal: true

require "csvimporter/concerns/model/base"
require "csvimporter/concerns/model/attributes"

module Csvimporter
  module Model
    extend ActiveSupport::Concern

    include Base
    include Attributes
  end
end
