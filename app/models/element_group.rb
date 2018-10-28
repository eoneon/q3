class ElementGroup < ApplicationRecord
  belongs_to :elementable, polymorphic: true
  belongs_to :element_kind
end
