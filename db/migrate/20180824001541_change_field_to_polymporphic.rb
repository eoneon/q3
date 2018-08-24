class ChangeFieldToPolymporphic < ActiveRecord::Migration[5.1]
  def change
    rename_column :field_groups, :field_id, :fieldable_id
    add_column :field_groups, :fieldable_type, :string
  end
end
