class MediumGroup < ProductPart
  has_many :item_groups, as: :origin, dependent: :destroy
  #has_many :categories, through: :item_groups, source: :target, source_type: "Category"
end
