class Category < ApplicationRecord
  include Importable

  has_many :field_groups, as: :fieldable
  has_many :fields, through: :field_groups

  has_many :sub_categories, dependent: :destroy
  #has_many :sub_categories, as: :categorizable
  has_many :dimensions, through: :sub_categories, source: :categorizable, source_type: "Dimension"

  has_many :items

  def sorted_field_groups
    self.field_groups.order(:sort)
  end

  def sorted_sub_categories
    self.sub_categories.order(:sort)
    #self.sub_categories.where(categorizable_type: categorizable).order(:sort)
  end

  def categorizable_types
    ['Dimension']
  end

  def categorizable_list(categorizable)
    self.sub_categories.where(categorizable_type: categorizable).order(:sort)
  end

  # def categorizable_collection(categorizable)
  #   self.public_send(categorizable.downcase.pluralize)
  # end

  def sorted_dimensions
    self.sub_categories.where(categorizable_type: 'Dimension').order(:sort)
  end
end
