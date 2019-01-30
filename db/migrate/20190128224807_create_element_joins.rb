class CreateElementJoins < ActiveRecord::Migration[5.1]
  def change
    create_table :element_joins do |t|
      t.references :element, index: true
      t.references :poly_element, polymorphic: true, index: true
      t.integer :sort

      t.timestamps
    end
  end
end
