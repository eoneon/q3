class CreateInvoices < ActiveRecord::Migration[5.1]
  def change
    create_table :invoices do |t|
      t.string :name
      t.integer :invoice_number
      t.references :supplier, foreign_key: true

      t.timestamps
    end
  end
end
