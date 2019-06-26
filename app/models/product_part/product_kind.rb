class ProductKind < ProductPart
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :products, through: :item_groups, source: :target, source_type: "Product"
  has_many :product_kind_fields, through: :item_groups, source: :target, source_type: "ProductKindField"
  has_many :product_kinds, through: :item_groups, source: :target, source_type: "ProductKind"
  has_many :media, through: :item_groups, source: :target, source_type: "Medium"
  has_many :materials, through: :item_groups, source: :target, source_type: "Material"
  has_many :sub_media, through: :item_groups, source: :target, source_type: "SubMedium"
  has_many :editions, through: :item_groups, source: :target, source_type: "Edition"
  has_many :mountings, through: :item_groups, source: :target, source_type: "Mounting"
  has_many :signatures, through: :item_groups, source: :target, source_type: "Signature"
  has_many :certificates, through: :item_groups, source: :target, source_type: "Certificate"
end
