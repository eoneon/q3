class Category < ApplicationRecord
  include Importable

  has_many :element_joins, as: :poly_element, dependent: :destroy
  has_many :elements, through: :element_joins

  has_many :field_groups, as: :fieldable, dependent: :destroy
  has_many :fields, through: :field_groups

  has_many :element_groups, as: :elementable, dependent: :destroy
  has_many :element_kinds, through: :element_groups

  has_many :item_types, dependent: :destroy
  has_many :items

  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 254 }

  def sorted_field_groups
    self.field_groups.order(:sort)
  end

  def sorted_element_groups
    self.element_groups.order(:sort)
  end

  def sorted_element_joins
    self.element_joins.order(:sort)
  end

  #before_create :set_sort

  # def set_sort
  #   total = Category.count
  #   self.sort = total > 0 ? total + 1 : 1
  # end

  # def sorted_categories
  #   Category.all.order(:sort)
  # end

  # def categorizable_types
  #   ['Dimension', 'Certificate']
  # end
end
