class OptionGroup < ProductPart
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :option_groups, through: :item_groups, source: :target, source_type: "OptionGroup"
  has_many :product_kinds, through: :item_groups, source: :target, source_type: "ProductKind"
  has_many :media, through: :item_groups, source: :target, source_type: "Medium"
  has_many :materials, through: :item_groups, source: :target, source_type: "Material"
  has_many :editions, through: :item_groups, source: :target, source_type: "Edition"
  has_many :signatures, through: :item_groups, source: :target, source_type: "Signature"
  has_many :certificates, through: :item_groups, source: :target, source_type: "Certificate"
  has_many :mountings, through: :item_groups, source: :target, source_type: "Mounting"
  has_many :dimensions, through: :item_groups, source: :target, source_type: "Dimension"
end
