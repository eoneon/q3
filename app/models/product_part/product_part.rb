class ProductPart < ApplicationRecord
  include Importable
  include Sti
  #include MediumBuild
  #extend BuildSet

  validates :type, presence: true
  validates :name, presence: true

  before_create :set_booleans

  def set_booleans
    self.category = true
    self.display_name = true
  end

  def sti_field_type
    get_klass_name + 'Field'
  end
end
