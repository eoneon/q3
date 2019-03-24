class ItemValue < ApplicationRecord
  include Importable
  include Sti

  after_initialize do
    self.type = self.class.name
  end

  # def grouped_subklass(target)
  #   self.item_groups.where(target_type: target).order(:sort)
  # end
  #
  # def self.subklass_list
  #   ["ProductKindValue", "MediumValue", "MaterialValue", "SubMediumValue", "EditionValue", "DimensionValue", "MountingValue", "SignatureValue", "CertificateValue"]
  # end
end
