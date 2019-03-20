class SignatureField < ItemField
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :signature_values, through: :item_groups, source: :target, source_type: "SignatureValue"
end
