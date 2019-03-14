class Certificate < ProductPart
  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :product_kinds, through: :item_groups, source: :target, source_type: "ProductKind"
  has_many :certificate_fields, through: :item_groups, source: :target, source_type: "CertificateField"

  after_initialize do
    self.type = 'Certificate'
  end
end
