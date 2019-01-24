class ValueGroup < ApplicationRecord
  #belongs_to :item
  belongs_to :value
  belongs_to :field

  before_create :set_sort

  def set_sort
    self.sort = field.sorted_value_groups.count == 0 ? 1 : field.sorted_value_groups.count + 1
  end
end
