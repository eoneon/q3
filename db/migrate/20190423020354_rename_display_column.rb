class RenameDisplayColumn < ActiveRecord::Migration[5.1]
  def change
    rename_column :product_parts, :display, :display_name
  end
end
