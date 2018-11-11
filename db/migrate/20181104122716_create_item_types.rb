class CreateItemTypes < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    create_table :item_types do |t|
      t.integer :sort
      t.hstore :properties
      t.references :artist, foreign_key: true, index: true

      t.timestamps
    end
    add_index :item_types, :properties, using: :gist
  end
end
