class ProductPart < ApplicationRecord
  include Importable
  include Sti

  def sti_field_type
    get_klass_name + 'Field'
  end
end
