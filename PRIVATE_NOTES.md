# Commands

## Update System Configuration

gem install bundler:2.2.25

## Update gems

bundle install --gemfile='gemfiles/Gemfile.5.2' --retry 1
bundle install --gemfile='gemfiles/Gemfile.6.1' --retry 1

## Add Arch

bundle lock --add-platform x86_64-linux --gemfile gemfiles/Gemfile.5.2
bundle lock --add-platform x86_64-linux --gemfile gemfiles/Gemfile.6.1

## Run on specific Gemfile

BUNDLE_GEMFILE=gemfiles/Gemfile.5.2 bundle exec rake
BUNDLE_GEMFILE=gemfiles/Gemfile.6.1 bundle exec rake

## Access to console

 BUNDLE_GEMFILE=gemfiles/Gemfile.5.2 bin/console
 BUNDLE_GEMFILE=gemfiles/Gemfile.6.1 bin/console
