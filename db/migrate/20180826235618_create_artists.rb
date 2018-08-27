class CreateArtists < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    create_table :artists do |t|
      t.integer :artist_id
      t.hstore :properties

      t.timestamps
    end
    add_index :artists, :properties, using: :gist
  end
end
