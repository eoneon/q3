class ElementKind < ApplicationRecord
  include Importable

  has_many :element_joins, as: :poly_element, dependent: :destroy
  has_many :elements, through: :element_joins

  has_many :element_groups, dependent: :destroy
  has_many :categories, through: :element_groups, source: :elementable, source_type: "Category"

  has_many :field_groups, as: :fieldable, dependent: :destroy
  has_many :fields, through: :field_groups

  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 254 }
            
  def self.sorted_element_kinds
    ElementKind.all.order(:kind)
  end

  def sorted_field_groups
    self.field_groups.order(:sort)
  end

  def sorted_element_joins
    self.element_joins.order(:sort)
  end
end
