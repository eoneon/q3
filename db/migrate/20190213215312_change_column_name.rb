class ChangeColumnName < ActiveRecord::Migration[5.1]
  def change
    add_reference :items, :origin, polymorphic: true, index: true
    add_reference :items, :related_element, polymorphic: true, index: true
  end
end
