class RemoveFieldRefFromValues < ActiveRecord::Migration[5.1]
  def change
    remove_reference :values, :field, index: true, foreign_key: true
  end
end
