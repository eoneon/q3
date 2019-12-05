class ItemType < ApplicationRecord
  belongs_to :artist, optional: true
  belongs_to :category, optional: true

  def set_sort
    self.sort = artist.item_types.count == 0 ? 1 : artist.item_types.count + 1
  end
end
