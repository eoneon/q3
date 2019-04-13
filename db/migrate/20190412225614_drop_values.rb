class DropValues < ActiveRecord::Migration[5.1]
  def change
    drop_table :values
  end
end
