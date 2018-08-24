class ChangeRefNamesForFieldGroups < ActiveRecord::Migration[5.1]
  def change
    rename_column :field_groups, :fieldable_id, :field_id
    rename_column :field_groups, :category_id, :fieldable_id
  end
end
