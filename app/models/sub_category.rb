class SubCategory < ApplicationRecord
  belongs_to :categorizable, polymorphic: true
  belongs_to :category, optional: true

  # def set_sort
  #   self.sort = categorizable.sorted_field_groups.count == 0 ? 1 : fieldable.sorted_field_groups.count + 1
  # end
end
