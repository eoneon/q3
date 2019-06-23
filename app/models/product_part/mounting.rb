class Mounting < ProductPart
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :mountings, through: :item_groups, source: :target, source_type: "Mounting"
  has_many :dimensions, through: :item_groups, source: :target, source_type: "Dimension"
  has_many :materials, through: :item_groups, source: :target, source_type: "Material"
  
  has_many :mounting_fields, through: :item_groups, source: :target, source_type: "MountingField"
end
