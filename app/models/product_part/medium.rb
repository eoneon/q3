class Medium < ProductPart
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :products, through: :item_groups, source: :target, source_type: "Product"
  has_many :product_kinds, through: :item_groups, source: :target, source_type: "ProductKind"
  has_many :materials, through: :item_groups, source: :target, source_type: "Material"
  has_many :sub_media, through: :item_groups, source: :target, source_type: "SubMedium"
  has_many :editions, through: :item_groups, source: :target, source_type: "Edition"

  has_many :medium_fields, through: :item_groups, source: :target, source_type: "MediumField"
end
