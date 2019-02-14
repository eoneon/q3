class Product < ApplicationRecord
  include Importable

  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :element_kinds, through: :item_groups, source: :target, source_type: "ElementKind"
  #has_many :category_kinds, through: :item_groups, source: :target, source_type: "CategoryKind"

  def sorted_item_groups
    self.item_groups.order(:sort)
  end
end
