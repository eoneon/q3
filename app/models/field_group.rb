class FieldGroup < ApplicationRecord
  belongs_to :category
  belongs_to :field, optional: true

  # def set_sort
  # end
  #scope :siblings, -> {where(category_id: self.category_id)}
  # def self.siblings
  #   FieldGroup.where(category_id: self.category_id)
  # end

  # def parent
  #   category.fields
  # end
end
