module ProductSeed
  extend BuildSet
  #ProductSeed.populate

  def self.populate
    ElementType.populate
    OptionGroup.populate
    Product.populate
  end

end
