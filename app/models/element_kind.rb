class ElementKind < ApplicationRecord
  has_many :elements
  has_many :element_groups, dependent: :destroy
  has_many :categories, through: :element_groups, source: :elementable, source_type: "Category"
end
