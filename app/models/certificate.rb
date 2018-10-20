class Certificate < ApplicationRecord
  include Importable

  has_many :field_groups, as: :fieldable
  has_many :fields, through: :field_groups

  has_many :sub_categories, as: :categorizable, dependent: :destroy
  has_many :categories, through: :sub_categories

  def sorted_field_groups
    self.field_groups.order(:sort)
  end
end
