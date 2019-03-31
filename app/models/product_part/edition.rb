class Edition < ProductPart
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :media, through: :item_groups, source: :target, source_type: "Medium"
  has_many :edition_fields, through: :item_groups, source: :target, source_type: "EditionField"

  # after_initialize do
  #   self.type = 'Edition'
  # end
end
