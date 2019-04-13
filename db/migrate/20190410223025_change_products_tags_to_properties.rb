class ChangeProductsTagsToProperties < ActiveRecord::Migration[5.1]
  def change
    rename_column :products, :tags, :properties
  end
end
