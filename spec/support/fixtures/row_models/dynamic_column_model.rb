# frozen_string_literal: true

class DynamicColumnModel
  include Csvimporter::Model

  column :first_name
  column :last_name
  dynamic_column :skills
end

#
# Import
#
class DynamicColumnImportModel < DynamicColumnModel
  include Csvimporter::Import
end
