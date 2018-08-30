class Value < ApplicationRecord
  belongs_to :field

  has_many :value_groups, dependent: :destroy
  has_many :items, through: :value_groups

  # def self.field_keys
  #   %w[type parent title body both attribute selected display_hidden display_none]
  # end
end
