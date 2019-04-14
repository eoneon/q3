class AddDetailsToProductParts < ActiveRecord::Migration[5.1]
  def change
    add_column :product_parts, :category, :boolean
    add_column :product_parts, :display, :boolean
  end
end
