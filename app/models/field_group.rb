class FieldGroup < ApplicationRecord
  belongs_to :category
  belongs_to :field, optional: true
end
