module ProductSeed
  extend BuildSet
  #ProductSeed.populate
  def self.populate
    Product.populate
    OptionGroupSet.populate
    OptionGroupAssoc.populate
  end
end
