class ItemGroup < ApplicationRecord
  belongs_to :origin, polymorphic: true
  belongs_to :target, polymorphic: true

  before_create :set_sort

  def set_sort
    count = origin.sti_item_groups(target_type).count
    self.sort = count == 0 ? 1 : count + 1
  end
end
