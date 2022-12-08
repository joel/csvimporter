# frozen_string_literal: true

class BasicRowModel
  include Csvimporter::Model

  column :string1
  column :string2, header: "String 2"
end

#
# Import
#
class BasicImportModel < BasicRowModel
  include Csvimporter::Import
end