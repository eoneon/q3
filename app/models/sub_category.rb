class SubCategory < ApplicationRecord
  belongs_to :categorizable, polymorphic: true
  belongs_to :category, optional: true
end
