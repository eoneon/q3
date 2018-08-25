class RenameCategorizableToSubCategories < ActiveRecord::Migration[5.1]
  def change
    rename_table :categorizables, :sub_categories 
  end
end
