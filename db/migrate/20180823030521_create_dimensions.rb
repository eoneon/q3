class CreateDimensions < ActiveRecord::Migration[5.1]
  def change
    create_table :dimensions do |t|
      t.string :name
      t.integer :sort

      t.timestamps
    end
  end
end
