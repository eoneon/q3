class CertificateValue < ItemValue
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :certificate_fields, through: :item_groups, source: :target, source_type: "CertificateField"
end
