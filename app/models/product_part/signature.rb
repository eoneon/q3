class Signature < ProductPart
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :product_kinds, through: :item_groups, source: :target, source_type: "ProductKind"

  has_many :signature_fields, through: :item_groups, source: :target, source_type: "SignatureField"

  # after_initialize do
  #   self.type = 'Signature'
  # end
end
