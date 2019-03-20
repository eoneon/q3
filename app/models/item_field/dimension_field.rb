class DimensionField < ItemField
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :dimensions, through: :item_groups, source: :target, source_type: "Dimension"
  has_many :dimension_values, through: :item_groups, source: :target, source_type: "DimensionValue"
end
