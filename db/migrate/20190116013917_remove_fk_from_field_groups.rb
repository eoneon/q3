class RemoveFkFromFieldGroups < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key "field_groups", "categories"
  end
end
