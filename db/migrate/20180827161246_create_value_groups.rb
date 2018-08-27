class CreateValueGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :value_groups do |t|
      t.references :item, foreign_key: true
      t.references :value, foreign_key: true

      t.timestamps
    end
  end
end
