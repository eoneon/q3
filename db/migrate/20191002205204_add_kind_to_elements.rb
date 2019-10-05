class AddKindToElements < ActiveRecord::Migration[5.1]
  def change
    add_column :elements, :kind, :text
  end
end
