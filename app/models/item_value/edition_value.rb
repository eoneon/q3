class EditionValue < ItemValue
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :edition_fields, through: :item_groups, source: :target, source_type: "EditionField"
end
