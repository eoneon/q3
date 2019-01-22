class ValueGroup < ApplicationRecord
  belongs_to :item
  belongs_to :value
  belongs_to :field
end
