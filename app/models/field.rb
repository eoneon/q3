class Field < ApplicationRecord
  include Importable

  has_many :field_groups, dependent: :destroy
  has_many :element_kinds, through: :field_groups, source: :fieldable, source_type: "ElementKind"
  has_many :elements, through: :field_groups, source: :fieldable, source_type: "Element"

  has_many :value_groups, dependent: :destroy
  has_many :values, through: :value_groups

  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 254 }

  validates :field_type,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 254 }

  def sorted_value_groups
    self.value_groups.order(:sort)
  end
end
