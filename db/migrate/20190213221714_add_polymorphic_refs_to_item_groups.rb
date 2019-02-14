class AddPolymorphicRefsToItemGroups < ActiveRecord::Migration[5.1]
  def change
    add_reference :item_groups, :origin, polymorphic: true, index: true
    add_reference :item_groups, :target, polymorphic: true, index: true
  end
end
