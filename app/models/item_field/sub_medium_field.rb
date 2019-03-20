class SubMediumField < ItemField
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :sub_medium_values, through: :item_groups, source: :target, source_type: "SubMediumValue"
end
