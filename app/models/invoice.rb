class Invoice < ApplicationRecord
  belongs_to :supplier, optional: true
  has_many :items, dependent: :destroy

  # def ordered_skus
  #   items.order(:sku)
  # end
  #
  # def sku_pos(item)
  #   ordered_skus.index(item) + 1
  # end

  def supplier_name
    supplier.name if supplier
  end

  def display
    "#{name}: #{invoice_number}" #if invoice.present?
  end
end
