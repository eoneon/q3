class Material < ProductPart
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :products, through: :item_groups, source: :target, source_type: "Product"
  #has_many :product_kinds, through: :item_groups, source: :target, source_type: "ProductKind"
  has_many :media, through: :item_groups, source: :target, source_type: "Medium"
  has_many :dimensions, through: :item_groups, source: :target, source_type: "Dimension"
  has_many :mountings, through: :item_groups, source: :target, source_type: "Mounting"

  after_initialize do
    self.type = 'Material'
  end
end
