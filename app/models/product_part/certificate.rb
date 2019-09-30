class Certificate < ProductPart
  include CertificateType
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :product_kinds, through: :item_groups, source: :target, source_type: "ProductKind"
  has_many :certificates, through: :item_groups, source: :target, source_type: "Certificate"
  has_many :certificate_fields, through: :item_groups, source: :target, source_type: "CertificateField"
end
