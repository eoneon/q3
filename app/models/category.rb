class Category < ApplicationRecord
  include Importable

  has_many :field_groups, as: :fieldable
  has_many :fields, through: :field_groups

  has_many :element_groups, as: :elementable
  has_many :element_kinds, through: :element_groups

  has_many :sub_categories, dependent: :destroy
  has_many :dimensions, through: :sub_categories, source: :categorizable, source_type: 'Dimension'
  has_many :certificates, through: :sub_categories, source: :categorizable, source_type: 'Certificate'

  has_many :items

  def sorted_field_groups
    self.field_groups.order(:sort)
  end

  def sorted_sub_categories
    self.sub_categories.order(:sort)
  end

  def categorizable_types
    ['Dimension', 'Certificate']
  end

  def sorted_subcategories(categorizable)
    self.sub_categories.where(categorizable_type: categorizable).order(:sort)
  end

  def sorted_dimensions
    self.sub_categories.where(categorizable_type: 'Dimension').order(:sort)
  end
end
