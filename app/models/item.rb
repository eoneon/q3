class Item < ApplicationRecord
  belongs_to :artist, optional: true
  belongs_to :category, optional: true

  has_many :value_groups, dependent: :destroy
  has_many :values, through: :value_groups
end
