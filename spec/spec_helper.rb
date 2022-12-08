# frozen_string_literal: true

begin
  require "pry"
rescue LoadError
end

require "csvimporter"

# Requires shared contexts
# in spec/shared_contexts/ and its subdirectories.
Dir["./spec/shared_contexts/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
