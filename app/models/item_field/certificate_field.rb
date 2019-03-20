class CertificateField < ItemField
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :certificate_values, through: :item_groups, source: :target, source_type: "CertificateValue"
end
