class DropDimension < ActiveRecord::Migration[5.1]
  def change
    drop_table :dimensions
  end
end
