class CreateCategoryKinds < ActiveRecord::Migration[5.1]
  def change
    create_table :category_kinds do |t|
      t.string :name
      t.integer :sort
      t.hstore :tags
      
      t.timestamps
    end
  end
end
