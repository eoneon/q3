class Field < ApplicationRecord
  include Importable
  
  has_many :field_groups, dependent: :destroy
  has_many :categories, through: :field_groups
end
