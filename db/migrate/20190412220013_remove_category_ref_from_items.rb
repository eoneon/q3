class RemoveCategoryRefFromItems < ActiveRecord::Migration[5.1]
  def change
    remove_reference :items, :category, index: true, foreign_key: true
  end
end
