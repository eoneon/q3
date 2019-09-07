class IdentifierGroup < ProductPart
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :identifier_groups, through: :item_groups, source: :target, source_type: "IdentifierGroup"
  has_many :categories, through: :item_groups, source: :target, source_type: "Category"
end
