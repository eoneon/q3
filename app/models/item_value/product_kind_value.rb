class ProductKindValue < ItemValue
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :product_kind_fields, through: :item_groups, source: :target, source_type: "ProductKindField"
end
