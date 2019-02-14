class RemoveItemGroupRefs < ActiveRecord::Migration[5.1]
  def change
    remove_reference :item_groups, :left_item, polymorphic: true, index: true
    remove_reference :item_groups, :right_item, polymorphic: true, index: true
  end
end
