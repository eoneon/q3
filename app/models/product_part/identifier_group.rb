class IdentifierGroup < ProductPart
  has_many :item_groups, as: :origin, dependent: :destroy
end
