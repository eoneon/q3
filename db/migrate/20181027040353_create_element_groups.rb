class CreateElementGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :element_groups do |t|
      t.references :element_kind, index: true
      t.references :elementable, polymorphic: true, index: true
      t.integer :sort
      t.timestamps
    end
  end
end
