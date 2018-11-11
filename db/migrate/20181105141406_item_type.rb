class ItemType < ActiveRecord::Migration[5.1]
  def change
    add_column :item_types, :name, :string
  end
end
