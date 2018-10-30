class ElementGroup < ApplicationRecord
  belongs_to :elementable, polymorphic: true
  belongs_to :element_kind

  before_create :set_sort

  def set_sort
    self.sort = elementable.element_groups.count == 0 ? 1 : elementable.element_groups.count + 1
  end
end
