class Field < ApplicationRecord
  include Importable

  has_many :field_groups
  has_many :categories, through: :field_groups, source: :fieldable, source_type: "Category"
  has_many :dimensions, through: :field_groups, source: :fieldable, source_type: "Dimension"

  has_many :values

  def display
    "(#{id}) #{name}"
  end
end
