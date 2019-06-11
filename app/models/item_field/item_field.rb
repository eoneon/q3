class ItemField < ApplicationRecord
  include Importable
  include Sti

  validates :type, presence: true
  validates :field_name, presence: true
  #validates :field_type, presence: true

  before_create :set_field_type

  def set_field_type
    self.field_type = "select_field"
  end

  def sti_value_type
    get_klass_name.sub('Field', 'Value')
  end

  def self.field_type_list
    ["select_field", "text_field", "number_field", "text_area", "check_box"]
  end
end
