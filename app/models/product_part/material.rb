class Material < ProductPart
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :materials, through: :item_groups, source: :target, source_type: "Material"
  has_many :products, through: :item_groups, source: :target, source_type: "Product"
  has_many :media, through: :item_groups, source: :target, source_type: "Medium"
  has_many :dimensions, through: :item_groups, source: :target, source_type: "Dimension"
  has_many :mountings, through: :item_groups, source: :target, source_type: "Mounting"
  #has_many :product_kinds, through: :item_groups, source: :target, source_type: "ProductKind"

  has_many :material_fields, through: :item_groups, source: :target, source_type: "MaterialField"
end
