class Product < ApplicationRecord
  include Importable
  include Sti

  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :product_kinds, through: :item_groups, source: :target, source_type: "ProductKind"
  has_many :product_kind_values, through: :item_groups, source: :target, source_type: "ProductKindValue"
  has_many :materials, through: :item_groups, source: :target, source_type: "Material"
  has_many :material_values, through: :item_groups, source: :target, source_type: "MaterialValue"
  has_many :media, through: :item_groups, source: :target, source_type: "Medium"
  has_many :media_values, through: :item_groups, source: :target, source_type: "MediumValue"

  def sorted_groups
    self.item_groups.order(:sort)
  end
end
