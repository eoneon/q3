class SignatureValue < ItemValue
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :signature_fields, through: :item_groups, source: :target, source_type: "SignatureField"
end
