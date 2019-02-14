class RemoveItemRefs < ActiveRecord::Migration[5.1]
  def change
    remove_reference :items, :origin, polymorphic: true, index: true
    remove_reference :items, :related_element, polymorphic: true, index: true
  end
end
