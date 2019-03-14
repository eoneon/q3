class SubMedium < ProductPart
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :media, through: :item_groups, source: :target, source_type: "Medium"

  has_many :sub_medium_fields, through: :item_groups, source: :target, source_type: "SubMediumField"

  after_initialize do
    self.type = 'SubMedium'
  end
end
