class CreateItems < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    create_table :items do |t|
      t.integer :sku
      t.integer :retail
      t.references :artist, foreign_key: true, index: true
      t.hstore :properties

      t.timestamps
    end
    add_index :items, :properties, using: :gist
  end
end
