class Field < ApplicationRecord
  has_many :field_groups, dependent: true
  has_many :categories, through: :field_groups
end
