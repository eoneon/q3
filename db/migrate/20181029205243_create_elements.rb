class CreateElements < ActiveRecord::Migration[5.1]
  def change
    create_table :elements do |t|
      t.string :name
      t.string :kind
      t.integer :sort
      t.references :element_kind, foreign_key: true

      t.timestamps
    end
  end
end
