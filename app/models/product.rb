class Product < ApplicationRecord
  include Importable
  include Sti

  has_many :item_groups, as: :origin, dependent: :destroy
  has_many :product_kinds, through: :item_groups, source: :target, source_type: "ProductKind"
  has_many :materials, through: :item_groups, source: :target, source_type: "Material"
  has_many :media, through: :item_groups, source: :target, source_type: "Medium"
end
