# frozen_string_literal: true

class FileRowModel
  include Csvimporter::Model
  include Csvimporter::Model::FileModel

  row :alpha
  row :beta, header: "String 2"

  class << self
    def format_header(column_name, _context)
      ":: - #{column_name} - ::"
    end
  end
end

#
# Import
#
class FileImportModel < FileRowModel
  include Csvimporter::Import
  include Csvimporter::Import::FileModel
end
