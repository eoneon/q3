class AddPropertiesToItemValues < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    add_column :item_values, :properties, :hstore
    
    add_index :item_values, :properties, using: :gist
  end
end
