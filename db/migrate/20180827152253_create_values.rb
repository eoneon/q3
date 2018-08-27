class CreateValues < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    create_table :values do |t|
      t.string :name
      t.hstore :properties
      t.references :field, foreign_key: true, index: true

      t.timestamps
    end
    add_index :values, :properties, using: :gist
  end
end
