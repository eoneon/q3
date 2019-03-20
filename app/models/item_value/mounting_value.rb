class MountingValue < ItemValue
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :mounting_fields, through: :item_groups, source: :target, source_type: "MountingField"
end
