class MaterialField < ItemField
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :materials, through: :item_groups, source: :target, source_type: "Material"
  has_many :material_values, through: :item_groups, source: :target, source_type: "MaterialValue"
end
