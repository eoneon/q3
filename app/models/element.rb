class Element < ApplicationRecord
  has_many :field_groups, as: :fieldable
  has_many :fields, through: :field_groups

  belongs_to :element_kind

  before_create :set_sort

  def set_sort
    self.sort = element_kind.elements.count == 0 ? 1 : element_kind.elements.count + 1
  end

  def sorted_field_groups
    self.field_groups.order(:sort)
  end
end
