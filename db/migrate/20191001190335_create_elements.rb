class CreateElements < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    create_table :elements do |t|
      t.string :name
      t.hstore :tags
      t.timestamps
    end
  end
end
