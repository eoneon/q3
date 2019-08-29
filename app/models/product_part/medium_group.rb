class MediumGroup < ProductPart
  has_many :item_groups, as: :origin, dependent: :destroy
  #has_many :categories, through: :item_groups, source: :target, source_type: "Category"
  has_many :medium_groups, through: :item_groups, source: :target, source_type: "MediumGroup"
  has_many :product_kinds, through: :item_groups, source: :target, source_type: "ProductKind"
  has_many :media, through: :item_groups, source: :target, source_type: "Medium"
  has_many :materials, through: :item_groups, source: :target, source_type: "Material"
end
