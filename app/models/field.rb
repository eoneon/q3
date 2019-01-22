class Field < ApplicationRecord
  #include Importable

  has_many :field_groups, dependent: :destroy
  has_many :elements, through: :field_groups, source: :fieldable, source_type: "Element"

  has_many :element_kinds, through: :field_groups, source: :fieldable, source_type: "ElementKind"
  has_many :value_groups, dependent: :destroy
  has_many :values, through: :value_groups
end
