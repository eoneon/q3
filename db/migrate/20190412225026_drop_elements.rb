class DropElements < ActiveRecord::Migration[5.1]
  def change
    drop_table :elements
  end
end
