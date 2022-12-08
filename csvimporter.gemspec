# frozen_string_literal: true

require_relative "lib/csvimporter/version"

Gem::Specification.new do |spec|
  spec.name          = "csvimporter"
  spec.version       = Csvimporter::VERSION
  spec.authors       = ["Joel Azemar"]
  spec.email         = ["joel.azemar@gmail.com"]

  spec.summary       = "Csvimporter is a simple gem to import your data from CSV format."
  spec.description   = "Write in a nice way how to import any object"

  spec.required_ruby_version = Gem::Requirement.new(">= 2.7")

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "5.2.8.1"
  spec.add_dependency "active_warnings"
  spec.add_dependency "inherited_class_var"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-performance"
  spec.add_development_dependency "rubocop-rake"
  spec.add_development_dependency "rubocop-rspec"

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
