module ProductsHelper
  # def option_group(product)
  #   product.elements.where(name: ['option-group-set', 'option-group'])
  # end

  def build_option_group_card(product)
    set =[]
    OptionGroupAssoc.kind_and_option_type_pairs.each do |pair|
      if product.nested_element_kind(pair.first) && product.product_option_group(pair.first, pair.last).any?
        option_group = product.product_option_group(pair.first, pair.last).first.kind
        options = product.product_options(pair.first, pair.last)
        set << h = {option_group: option_group, options: options}
      end
    end
    set
  end

end
