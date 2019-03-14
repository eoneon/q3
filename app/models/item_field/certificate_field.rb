class CertificateField < ItemField
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :certificates, through: :item_groups, source: :target, source_type: "Certificate"
end
