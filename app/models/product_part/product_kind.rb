class ProductKind < ProductPart
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :products, through: :item_groups, source: :target, source_type: "Product"
  has_many :product_kind_fields, through: :item_groups, source: :target, source_type: "ProductKindField"
  has_many :media, through: :item_groups, source: :target, source_type: "Medium"
  has_many :signatures, through: :item_groups, source: :target, source_type: "Signature"
  has_many :certificates, through: :item_groups, source: :target, source_type: "Certificate"

  # after_initialize do
  #   self.type = 'ProductKind'
  # end
end
