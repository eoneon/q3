class Dimension < ProductPart
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :materials, through: :item_groups, source: :target, source_type: "Material"
  has_many :dimension_fields, through: :item_groups, source: :target, source_type: "DimensionField"
end
