class ItemGroup < ApplicationRecord
  belongs_to :origin, polymorphic: true
  belongs_to :target, polymorphic: true

  before_create :set_sort

  def set_sort
    count = set_count
    self.sort = count == 0 ? 1 : count + 1
  end

  def set_count
    if ["ProductPart", "ItemField", "ItemValue"].include?(self.origin_type)
      origin.sti_item_groups(target_type).count
    else
      origin.item_groups.count
    end
  end
end
