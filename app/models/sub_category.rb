class SubCategory < ApplicationRecord
  belongs_to :categorizable, polymorphic: true
  belongs_to :category, optional: true

  before_create :set_sort

  def set_sort
    sorted_categorizables = "sorted_" + self.categorizable_type.pluralize.underscore
    self.sort = category.public_send(sorted_categorizables).count == 0 ? 1 : category.public_send(sorted_categorizables).count + 1
    #self.sort = fieldable.sorted_field_groups.count == 0 ? 1 : fieldable.sorted_field_groups.count + 1
  end
end
