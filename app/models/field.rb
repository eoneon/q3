class Field < ApplicationRecord
  #include Importable

  has_many :field_groups, dependent: :destroy
  #has_many :categories, through: :field_groups, source: :fieldable, source_type: "Category"
  has_many :elements, through: :field_groups, source: :fieldable, source_type: "Element"
  #has_many :dimensions, through: :field_groups, source: :fieldable, source_type: "Dimension"
  has_many :values, dependent: :destroy
end
