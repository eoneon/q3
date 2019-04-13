class DropFields < ActiveRecord::Migration[5.1]
  def change
    drop_table :fields
  end
end
