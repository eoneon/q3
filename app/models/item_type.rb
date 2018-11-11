class ItemType < ApplicationRecord
  belongs_to :artist
  belongs_to :category
end
