class MountingField < ItemField
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :mountings, through: :item_groups, source: :target, source_type: "Mounting"
end
