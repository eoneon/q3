class SubMediumGroup < ProductPart
  has_many :item_groups, as: :origin, dependent: :destroy
end
