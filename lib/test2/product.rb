module Product
  extend BuildSet
  # set = Product::populate

  def self.populate
    set =[]
    Medium.constants.each do |medium_class|
      scoped_constant = to_scoped_constant(Medium, medium_class)
      build_hsh = build_hsh([['category', scoped_constant.category], ['medium', scoped_constant.name], ['medium-option', scoped_constant.options]])
      assoc_unless_included(origin: build_hsh[:category], target: build_hsh[:medium])
      build_product_sets(build_hsh, scoped_constant, set)
    end
    set.map {|product_hsh| build_product(product_hsh)}
  end

  def self.build_hsh(attr_sets, h={})
    attr_sets.map {|set| h[to_snake(set.first).to_sym] = find_or_create_by(kind: set.first, name: set.last)}
    h
  end

  def self.build_product_sets(build_hsh, scoped_constant, set)
    build_hsh[:medium_option].each do |medium_option|
      scoped_constant.material.detect {|set| set.first.include?(medium_option.name)}.last.map {|material_name| find_or_create_by(kind: 'material', name: material_name)}.each do |material|
        product_hsh = {category: build_hsh[:category], medium: build_hsh[:medium], option: medium_option, material: material}
        set << set_product_params(scoped_constant, product_hsh)
      end
    end
    set
  end

  def self.set_product_params(scoped_constant, product_hsh)
    product_set = product_hsh.values
    product_tags = product_set.map {|obj| [:"#{to_snake(obj.kind)}", to_snake(obj.name)]}.to_h #
    product_tags[:assoc_pairs] = format_assoc_pairs(product_set)
    product_name = format_product_name(scoped_constant.name_order, product_hsh)
    h = {product_set: product_set, product_name: product_name, product_tags: product_tags}
  end

  def self.format_assoc_pairs(product_set)
    product_set.map {|obj| [obj.name, obj.id]}.flatten.join(',')
  end

  def self.format_product_name(name_order, product_hsh)
    name_set = format_name_set(name_order, product_hsh, name_set =[])
    name_set.map {|word| format_hyphens(word)}.join(' ').split(' ').reject {|word| word == 'standard'}.uniq.compact.join(' ')
  end

  def self.format_name_set(name_order, product_hsh, name_set =[])
    name_order.each do |k|
      if k == :option
        name_set << product_hsh[k].name
      else
       name_set << to_scoped_constant(k, product_hsh[k].name).format_name
      end
    end
    name_set
  end

  def self.format_hyphens(word)
    word != 'one-of-a-kind' ? word.split('-').join(' ') : word
  end

  def self.build_product(product_hsh)
    product = find_or_create_by(kind: 'product', name: product_hsh[:product_name])
    update_tags(product, product_hsh[:product_tags])
    product_hsh[:product_set].map {|target| assoc_unless_included(origin: product, target: target)}
  end

  def self.search
    set =[]
    Medium.constants.each do |medium_class|
      scoped_constant = to_scoped_constant(Medium, medium_class)
      category = to_snake(scoped_constant.category)
      medium = to_snake(scoped_constant.name)
      set << h = {scope_name: [category, medium].join('_').to_sym, category: category, medium: medium, search_text: scoped_constant.search_text}
    end
    set
  end

  def self.search_dropdown
    set = [['all products', :products]]
    search.each do |h|
      set << [h[:search_text], h[:scope_name]]
    end
    set
  end

  def self.product_types
    %w[standard limited_edition embellished_limited_edition embellished single_edition embellished_single_edition].map {|k| [k.to_sym, []]}.to_h
  end
  
end
