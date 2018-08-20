class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :fields
      t.integer :sort

      t.timestamps
    end
  end
end
