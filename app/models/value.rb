class Value < ApplicationRecord
  belongs_to :field

  has_many :value_groups, dependent: :destroy
  has_many :items, through: :value_groups

  #before_create :set_sort
  #after_save :set_parent

  # def set_sort
  #   total = Value.count
  #   self.sort = total > 0 ? total + 1 : 1
  # end

  # def sorted_categories
  #   Value.all.order(:sort)
  # end
  # def self.field_keys
  #   %w[type parent title body both attribute selected display_hidden display_none]
  # end
end
