class DropCategoryKinds < ActiveRecord::Migration[5.1]
  def change
    drop_table :category_kinds
  end
end
