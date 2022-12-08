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

class ChildImportModel < BasicImportModel
  validates :string1, absence: true
  validates :source_row, presence: true # HACK: before changing how children work
end

class ParentImportModel < BasicImportModel
  has_many :children, ChildImportModel
end
