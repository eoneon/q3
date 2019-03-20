class MaterialValue < ItemValue
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :material_fields, through: :item_groups, source: :target, source_type: "MaterialField"
end
