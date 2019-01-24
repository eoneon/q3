class AddSortToValueGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :value_groups, :sort, :integer
  end
end
