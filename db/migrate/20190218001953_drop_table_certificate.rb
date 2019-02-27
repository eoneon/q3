class DropTableCertificate < ActiveRecord::Migration[5.1]
  def change
    drop_table :certificates
  end
end
