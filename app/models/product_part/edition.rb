class Edition < ProductPart
  include EditionType
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :editions, through: :item_groups, source: :target, source_type: "Edition"
  has_many :media, through: :item_groups, source: :target, source_type: "Medium"
  has_many :edition_fields, through: :item_groups, source: :target, source_type: "EditionField"
  #has_many :product_kinds, through: :item_groups, source: :target, source_type: "ProductKind"
end
