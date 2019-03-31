class ItemField < ApplicationRecord
  include Importable
  include Sti

  validates :type, presence: true

  def sti_value_type
    get_klass_name.sub('Field', 'Value')
  end

  def self.field_type_list
    ["select_field", "text_field", "number_field", "text_area", "check_box"]
  end
end
