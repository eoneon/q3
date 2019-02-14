class Element < ApplicationRecord
  include Importable

  has_many :element_joins, dependent: :destroy

  has_many :categories, through: :element_joins, source: :poly_element, source_type: "Category"
  has_many :element_kinds, through: :element_joins, source: :poly_element, source_type: "ElementKind"

  has_many :field_groups, as: :fieldable, dependent: :destroy
  has_many :fields, through: :field_groups

  # validates :name,
  #           presence: true,
  #           uniqueness: { case_sensitive: false },
  #           length: { minimum: 3, maximum: 254 }

  def sorted_field_groups
    self.field_groups.order(:sort)
  end
end
