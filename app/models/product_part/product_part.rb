class ProductPart < ApplicationRecord
  include Importable
  include Sti

  validates :type, presence: true
  validates :name, presence: true
  
  def sti_field_type
    get_klass_name + 'Field'
  end
end
