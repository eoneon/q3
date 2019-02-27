class CreateProductParts < ActiveRecord::Migration[5.1]
  def change
    create_table :product_parts do |t|
      t.string :name
      t.string :type
      t.hstore :tags
      
      t.timestamps
    end
  end
end
