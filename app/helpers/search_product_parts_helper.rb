module SearchProductPartsHelper
  def product_kind_set
    pk_set =[]
    opt_group_values(product_kind_assoc).each do |key|
      origin = Category.find_by(name: key)
      pk_set << origin.product_kinds
    end
    pk_set.flatten(1)
  end
end
