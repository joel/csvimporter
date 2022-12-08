# Csvimporter

CsvBuilder is a simple gem to export your model in CSV format.

## Installation

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/csvimporter`. To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'csvimporter'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install csvimporter

## Usage

Want to export your User model into CSV format?

```ruby
class UserCsvRowObject < Csvimporter::RowObject
  def full_name
    "#{source_model.first_name} #{source_model.last_name} [#{context.group_name}]"
  end
end
```

NOTE: A CsvRowObject is unnecessary if the methods called by the exporter already exist and return the correct version of the string see CsvRowObject section.

```ruby
class UserCsvRowExporter
  include Csvimporter::Column
  include Csvimporter::Exporter

  column :full_name, header: "Name"
  column :first_name
  column :last_name
end
```

NOTE: See the column section for more detail on how it works.

```ruby
# == Schema Information
#
# Table name: users
#
#  id              :integer
#  first_name      :string(255)
#  last_name       :string(255)
class User < ActiveRecord::Base
end
```

## Exporter

```ruby
UserCsvRowExporter.generate(User.administrators, UserCsvRowObject, { context: { group_name: "Admin" }})
```

```
"Name,First name,Last name\nJohn Doe [Admin],John,Doe\n"
```

```ruby
UserCsvRowExporter.headers
```

```
['Name', 'First name', 'Last name']"
```

```ruby
UserCsvRowExporter.content(User.all, UserCsvRowObject, { context: { group_name: "Admin" }})
```

```
['John Doe [Admin]', 'John', 'Doe']
```

NOTE: the methods `content` and `generate` return a filtered result (See filter section); however, you have access to the methods `raw_content` and `raw_generate`, which are never filtered.

## Dynamic Column

To provide a dynamic headers/columns

```ruby
# == Schema Information
#
# Table name: users
#
#  id              :integer
#  first_name      :string(255)
#  last_name       :string(255)
class User < ActiveRecord::Base

  has_many :traits
end
```

```ruby
# == Schema Information
#
# Table name: traits
#
#  id              :integer
#  name            :string(255)
#  user_id         :integer
class Trait < ActiveRecord::Base
  belongs_to :user
end
```

```ruby
class UserCsvRowExporter
  include Csvimporter::Column
  include Csvimporter::DynamicColumn
  include Csvimporter::Exporter

  column :first_name
  column :last_name
  dynamic_column :traits
end
```

```ruby
class UserCsvRowObject < Csvimporter::RowObject
  def trait(trait_name)
    return 'YES' if source_model.traits.where(name: trait_name).exist?

    'NO'
  end
end
```

```ruby
UserCsvRowExporter.generate(User.all, context: { traits: Trait.all.pluck(:name) })
```

```
"First name, Last name, Openness, Conscientiousness, Extraversion, Agreeableness"
"      John,       Doe,       NO,                NO,           NO,           YES"
```

## Columns DSL

```ruby
class UserCsvRowExporter
  include Csvimporter::Column
  include Csvimporter::Exporter

  column :full_name, header: "Name"
  column :first_name
end
```

The column takes the name of the method that the exporter will call as a symbol. That symbol is converted into text for the CSV column export.

```
:full_name => "Full name"
```

That can be overridden with `:header` option

## Header DSL

If you want to evaluate a header dynamically against an object, you can do as follow:

```ruby
class NoteExporter

  column :id
  column :score, header: -> { "Note of the Board [#{name}]" }
end
```

This proc will be executed upon the record we pass to the exporter.

```ruby
NoteExporter.generate(board.notes, ::Csv::Builder::RowObjectType,  { context { record: board }})
```

## CsvRowObject

The `CsvRowObject` is optional if all the methods already return the correct version of the string.

```ruby
class User
  attr_accessor :first_name, :last_name

  def full_name
    "#{first_name} #{last_name}"
  end
end
```

The object can provide the `CsvRowObject`

```ruby
class User
  attr_accessor :first_name, :last_name

  def row_object(context)
    UserCsvRowObject.new(source_model: self, context: context)
  end
end
```

Or you can pass the `CsvRowObject` to the exporter itself, and the exporter will take care of the rest.

```ruby
collection = [User]
row_object_type = UserCsvRowObject
options = { context: { } }

Csvimporter::Exporter.generate(collection, row_object_type, options = {})
```

## Filters

The exporter comes with a filter that lets us optionally filter some columns. Think about the UI that lets us select the columns we want to export

```ruby
Csvimporter::Exporter.generate(collection, row_object_type, options = { context: { except: ['Full name'] }})
```

```
"First name, Last name"
"      John,       Doe"
```

```ruby
Csvimporter::Exporter.generate(collection, row_object_type, options = { context: { only: ['Last name'] }})
```

```
"Last name"
"      Doe"
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
