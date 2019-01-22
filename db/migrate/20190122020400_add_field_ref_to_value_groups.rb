class AddFieldRefToValueGroups < ActiveRecord::Migration[5.1]
  def change
    add_reference :value_groups, :field, foreign_key: true, index: true
  end
end
