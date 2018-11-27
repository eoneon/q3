class Field < ApplicationRecord
  include Importable

  has_many :field_groups, dependent: :destroy
  has_many :categories, through: :field_groups, source: :fieldable, source_type: "Category"
  has_many :element_kinds, through: :field_groups, source: :fieldable, source_type: "Element"
  has_many :dimensions, through: :field_groups, source: :fieldable, source_type: "Dimension"

  has_many :values
end
