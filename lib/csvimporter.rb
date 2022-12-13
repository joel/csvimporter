# frozen_string_literal: true

class Boolean; end unless defined? Boolean

require "csvimporter/version"

require "active_support"
require 'active_support/all'
# require "active_support/dependencies/autoload"

require "csv"
require "ostruct"
require "active_model"

require "csvimporter/public/model"
require "csvimporter/public/model/file_model"

require "csvimporter/public/import"
require "csvimporter/public/import/file_model"
require "csvimporter/public/import/file"
