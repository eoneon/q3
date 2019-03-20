class EditionField < ItemField
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :editions, through: :item_groups, source: :target, source_type: "Edition"
  has_many :edition_values, through: :item_groups, source: :target, source_type: "EditionValue"
end
