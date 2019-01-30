class Element < ApplicationRecord
  has_many :element_joins, dependent: :destroy
  has_many :elements, through: :element_joins, source: :poly_element, source_type: "Category"
  has_many :element_kinds, through: :element_joins, source: :poly_element, source_type: "ElementKind"

  has_many :field_groups, as: :fieldable, dependent: :destroy
  has_many :fields, through: :field_groups

  def sorted_field_groups
    self.field_groups.order(:sort)
  end
end
