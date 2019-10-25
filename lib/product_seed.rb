module ProductSeed
  extend BuildSet

  def self.populate
    ProductElement.populate
    Product.populate
    OptionGroup.populate
    ProductType.populate
  end
end
