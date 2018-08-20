class Category < ApplicationRecord
  has_many :field_groups, dependent: :destroy
  has_many :fields, through: :field_groups
end
