class CreateFieldGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :field_groups do |t|
      t.references :field, foreign_key: true, index: true
      t.references :category, foreign_key: true, index: true
      t.integer :sort

      t.timestamps
    end
  end
end
