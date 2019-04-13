class DropElementGroups < ActiveRecord::Migration[5.1]
  def change
    drop_table :element_groups
  end
end
