class FieldGroup < ApplicationRecord
  #belongs_to :category
  belongs_to :fieldable, polymorphic: true
  belongs_to :field, optional: true
end
