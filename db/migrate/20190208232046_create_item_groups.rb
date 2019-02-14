class CreateItemGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :item_groups do |t|
      t.references :left_item, polymorphic: true, index: true
      t.references :right_item, polymorphic: true, index: true
      t.timestamps
    end
  end
end
