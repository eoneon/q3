class DropElementJoin < ActiveRecord::Migration[5.1]
  def change
    drop_table :element_joins
  end
end
