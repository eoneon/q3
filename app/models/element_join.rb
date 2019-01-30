class ElementJoin < ApplicationRecord
  belongs_to :poly_element, polymorphic: true
  belongs_to :element

  before_create :set_sort

  def set_sort
    self.sort = poly_element.element_joins.count == 0 ? 1 : poly_element.element_joins.count + 1
  end
end
