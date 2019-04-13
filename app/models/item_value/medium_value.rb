class MediumValue < ItemValue
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :medium_fields, through: :item_groups, source: :target, source_type: "MediumField"
  has_many :products, through: :item_groups, source: :target, source_type: "Product"
end
