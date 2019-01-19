class ElementKind < ApplicationRecord
  has_many :elements, dependent: :destroy

  has_many :element_groups, dependent: :destroy
  has_many :categories, through: :element_groups, source: :elementable, source_type: "Category"

  has_many :field_groups, dependent: :destroy
  has_many :fields, through: :field_groups, source: :fielable, source_type: "ElementKind"

  def sorted_field_groups
    self.field_groups.order(:sort)
  end

  def sorted_elements
    self.elements.order(:sort)
  end
end
