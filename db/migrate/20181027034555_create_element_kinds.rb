class CreateElementKinds < ActiveRecord::Migration[5.1]
  def change
    create_table :element_kinds do |t|
      t.string :name
      t.string :kind

      t.timestamps
    end
  end
end
