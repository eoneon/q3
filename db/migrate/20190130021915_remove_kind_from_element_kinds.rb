class RemoveKindFromElementKinds < ActiveRecord::Migration[5.1]
  def change
    remove_column :element_kinds, :kind
  end
end
