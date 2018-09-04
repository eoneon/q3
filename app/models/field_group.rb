class FieldGroup < ApplicationRecord
  belongs_to :fieldable, polymorphic: true
  belongs_to :field, optional: true

  before_create :set_sort

  def set_sort
    self.sort = fieldable.sorted_field_groups.count == 0 ? 1 : fieldable.sorted_field_groups.count + 1
  end
end
