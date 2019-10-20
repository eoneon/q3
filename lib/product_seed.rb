module ProductSeed
  extend BuildSet

  def self.populate
    ProductElement.populate
    Product.populate
    #ProductType.populate
  end
end
