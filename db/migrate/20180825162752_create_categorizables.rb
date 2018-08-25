class CreateCategorizables < ActiveRecord::Migration[5.1]
  def change
    create_table :categorizables do |t|
      t.references :category, index: true
      t.references :categorizable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
