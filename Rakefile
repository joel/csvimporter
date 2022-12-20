# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

# RSpec::Core::RakeTask.new(:spec)

RSpec::Core::RakeTask.new(:spec) do |t|
  t.exclude_pattern = "./spec/csvimporter/public/import/file_spec.rb"
end

RSpec::Core::RakeTask.new(:spec_isolated) do |t|
  t.pattern = "./spec/csvimporter/public/import/file_spec.rb"
end

require "rubocop/rake_task"

RuboCop::RakeTask.new(:rubocop) do |task|
  task.options = ["-A"]
end

task default: %i[spec spec_isolated rubocop]
