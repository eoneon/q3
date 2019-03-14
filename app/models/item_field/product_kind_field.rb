class ProductKindField < ItemField
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :product_kinds, through: :item_groups, source: :target, source_type: "ProductKind"
end
