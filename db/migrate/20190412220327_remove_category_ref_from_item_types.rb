class RemoveCategoryRefFromItemTypes < ActiveRecord::Migration[5.1]
  def change
    remove_reference :item_types, :category, index: true
  end
end
