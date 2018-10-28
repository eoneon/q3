class ElementKind < ApplicationRecord
  has_many :categories, through: :element_groups, source: :elementable, source_type: "Category"
end
