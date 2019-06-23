class SubMedium < ProductPart
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :media, through: :item_groups, source: :target, source_type: "Medium"
  #has_many :product_kinds, through: :item_groups, source: :target, source_type: "ProductKind"
  has_many :sub_medium_fields, through: :item_groups, source: :target, source_type: "SubMediumField"
end
