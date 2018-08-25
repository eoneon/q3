class AddSortToCategorizable < ActiveRecord::Migration[5.1]
  def change
    add_column :categorizables, :sort, :integer
  end
end
