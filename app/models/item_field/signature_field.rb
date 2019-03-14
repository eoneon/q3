class SignatureField < ItemField
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :signatures, through: :item_groups, source: :target, source_type: "Signature"
end
