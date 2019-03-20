class SubMediumValue < ItemValue
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :sub_medium_fields, through: :item_groups, source: :target, source_type: "SubMediumField"
end
