class CategoryKind < ApplicationRecord
  has_many :item_groups, as: :right_item, dependent: :destroy
  has_many :products, through: :item_groups, source: :left_item, source_type: "Product"
end
