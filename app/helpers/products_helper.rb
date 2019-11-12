module ProductsHelper
  def option_group(product)
    product.elements.where(name: ['option-group-set', 'option-group'])
  end
end
