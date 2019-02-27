class Product < ApplicationRecord
  include Importable

  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :element_kinds, through: :item_groups, source: :target, source_type: "ElementKind"
  has_many :product_kinds, through: :item_groups, source: :target, source_type: "ProductKind"
  has_many :materials, through: :item_groups, source: :target, source_type: "Material"

  def sorted_item_groups
    self.item_groups.order(:sort)
  end
end
