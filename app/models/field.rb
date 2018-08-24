class Field < ApplicationRecord
  include Importable
  has_many :field_groups, as: :fieldable, dependent: :destroy
  has_many :categories, through: :field_groups
end
