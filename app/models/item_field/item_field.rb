class ItemField < ApplicationRecord
  include Importable
  include Sti

  after_initialize do
    self.type = self.class.name
  end

  # def grouped_subklass(target)
  #   self.item_groups.where(target_type: target).order(:sort)
  # end

  def sti_value_type
    get_klass_name.sub('Value', 'Field')
  end

  # def value_kollection_name
  #   self.class.name.underscore + '_value'
  # end
  #
  # def value_kollection
  #   self.public_send(value_kollection_name.pluralize)
  # end

  # def self.subklass_list
  #   ["ProductKindField", "MediumField", "MaterialField", "SubMediumField", "EditionField", "DimensionField", "MountingField", "SignatureField", "CertificateField"]
  # end

  def self.field_type_list
    ["select_field", "text_field", "number_field", "text_area", "check_box"]
  end
end
