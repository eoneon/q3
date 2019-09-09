class ProductKind < ProductPart
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :products, through: :item_groups, source: :target, source_type: "Product"
  has_many :identifier_groups, through: :item_groups, source: :target, source_type: "IdentifierGroup"
  has_many :product_kind_fields, through: :item_groups, source: :target, source_type: "ProductKindField"
  has_many :product_kinds, through: :item_groups, source: :target, source_type: "ProductKind"
  has_many :categories, through: :item_groups, source: :target, source_type: "Category"
  has_many :media, through: :item_groups, source: :target, source_type: "Medium" #obsolete? covered by :medium_groups
  has_many :materials, through: :item_groups, source: :target, source_type: "Material" #obsolete? covered by :medium_groups
  has_many :sub_media, through: :item_groups, source: :target, source_type: "SubMedium" #obsolete? covered by :sub_medium_option_groups? Yet to be completed
  has_many :editions, through: :item_groups, source: :target, source_type: "Edition" #obsolete? covered by :category yet to be finsihed?
  has_many :mountings, through: :item_groups, source: :target, source_type: "Mounting" #obsolete? covered by :identifier_groups
  has_many :signatures, through: :item_groups, source: :target, source_type: "Signature" #obsolete? covered by :identifier_groups
  has_many :certificates, through: :item_groups, source: :target, source_type: "Certificate" #obsolete? covered by :identifier_groups
end
