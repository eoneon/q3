class Product < ApplicationRecord
  include Importable
  include Sti

  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :elements, through: :item_groups, source: :target, source_type: "Element"
  
  has_many :product_kinds, through: :item_groups, source: :target, source_type: "ProductKind"
  has_many :product_kind_values, through: :item_groups, source: :target, source_type: "ProductKindValue"
  has_many :materials, through: :item_groups, source: :target, source_type: "Material"
  has_many :material_values, through: :item_groups, source: :target, source_type: "MaterialValue"
  has_many :media, through: :item_groups, source: :target, source_type: "Medium"
  has_many :media_values, through: :item_groups, source: :target, source_type: "MediumValue"

  has_many :editions, through: :item_groups, source: :target, source_type: "Edition"
  has_many :signatures, through: :item_groups, source: :target, source_type: "Signature"
  has_many :signature_fields, through: :item_groups, source: :target, source_type: "SignatureField"
  has_many :certificates, through: :item_groups, source: :target, source_type: "Certificate"
  has_many :certificate_fields, through: :item_groups, source: :target, source_type: "CertificateField"

  def sorted_groups
    self.item_groups.order(:sort)
  end
end
