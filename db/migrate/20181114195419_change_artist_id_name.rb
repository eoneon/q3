class ChangeArtistIdName < ActiveRecord::Migration[5.1]
  def change
    rename_column :artists, :artist_id, :admin_id
  end
end
