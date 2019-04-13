class DropElementKinds < ActiveRecord::Migration[5.1]
  def change
    drop_table :element_kinds
  end
end
