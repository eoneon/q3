class Category < ApplicationRecord
  include Importable

  has_many :field_groups, as: :fieldable
  has_many :fields, through: :field_groups

  has_many :sub_categories, dependent: :destroy
  #has_many :sub_categories, as: :categorizable
  has_many :dimensions, through: :sub_categories

  has_many :items

  #scope :first_category, -> {where(sort: 1)}

  def sorted_field_groups
    self.field_groups.order(:sort)
  end

  def sorted_sub_categories
    self.sub_categories.order(:sort)
  end
end
