class ElementKind < ApplicationRecord
  has_many :elements, dependent: :destroy
  has_many :element_groups, dependent: :destroy
  has_many :categories, through: :element_groups, source: :elementable, source_type: "Category"

  def sorted_elements
    self.elements.order(:sort)
  end
end
