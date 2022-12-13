# frozen_string_literal: true

class BasicRowModel
  include Csvimporter::Model

  column :alpha
  column :beta, header: "Beta Two"
end

#
# Import
#
class BasicImportModel < BasicRowModel
  include Csvimporter::Import
end
