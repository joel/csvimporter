# Csvimporter

Csvimporter it's the import part of Csvbuilder

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'csvbuilder'
gem 'csvimporter'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install csvimporter

## Usage

```ruby
module Models
  class CommentRowModel
    include Csvimporter::Model

    column :title
    column :body
  end
end
```

```ruby
module Imports
  class CommentImportRowModel < ::Models::CommentRowModel
    include Csvimporter::Import

    validates :title, presence: true
    validates :body, presence: true

    def comment
      Comment.new(attributes)
    end
  end
end

```

```ruby
options = {}
::Csvimporter::Import::File.new(file_path, ::Imports::CommentImportRowModel, options).each do |row_model|
  comment = row_model.comment
  comment.post = @post
  comment.save
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/csvimporter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/csvimporter/blob/main/CODE_OF_CONDUCT.md).

## License

No License

## Code of Conduct

Everyone interacting in the Csvimporter project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/csvimporter/blob/main/CODE_OF_CONDUCT.md).
