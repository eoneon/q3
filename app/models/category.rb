class Category < ApplicationRecord
  include Importable

  has_many :field_groups, as: :fieldable, dependent: :destroy
  has_many :fields, through: :field_groups

  def sorted_field_groups
    self.field_groups.order(:sort)
  end
end
