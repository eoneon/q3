class ItemGroup < ApplicationRecord
  belongs_to :origin, polymorphic: true
  belongs_to :target, polymorphic: true

  before_create :set_sort

  def set_sort
    self.sort = origin.item_groups.count == 0 ? 1 : origin.item_groups.count + 1
  end
end
