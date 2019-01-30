class RemoveElementKindRefFromElements < ActiveRecord::Migration[5.1]
  def change
    remove_reference :elements, :element_kind, index: true, foreign_key: true
  end
end
