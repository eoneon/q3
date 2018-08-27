class Item < ApplicationRecord
  belongs_to :artist, optional: true
  belongs_to :category, optional: true
end
