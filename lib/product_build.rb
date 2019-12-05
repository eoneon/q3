module ProductBuild
  extend BuildSet

  #BuildSet dependeny
  def build_product(product_set)                                                                #product_set = [[:category, category], [:sub_medium, sub_medium], [:medium, medium], [:material, material]]
    name_set = name_set(product_set)
    product = find_or_create_by(kind: 'product', name: product_name(name_set))
    update_tags(product, set_tags(product_set))
    obj_set(product_set).map {|target| assoc_unless_included(origin: product, target: target)}
  end

  def set_tags(product_set)
    product_set.map {|set| [set.first, hyph_word(set.last.name)]}.to_h
  end

  # def product_name(name_set)
  #   name_set = reject_extraneous(name_set)
  #   name_set = format_hand_pulled(name_set)
  #   name_set = format_sculpture(name_set)
  #   name_set.insert(-2, 'on') if Material.on_material.include?(name_set.last)
  #   reject_dup_words(name_set)
  # end
  #
  # def reject_extraneous(name_set)
  #   name_set - ['print medium', 'basic print', 'standard print', 'mixed medium']
  # end

  # def format_hand_pulled(name_set)
  #   if idx = name_set.index('hand pulled')
  #     name =  name_set.delete('hand pulled')
  #     name_set.insert(idx - 1, name)
  #   else
  #     name_set
  #   end
  # end

  # def format_sculpture(name_set)
  #   if name_set.first == 'sculpture'
  #     name_set[1..-1]
  #   else
  #     name_set
  #   end
  # end

  # def reject_dup_words(name_set, set=[])
  #   name_set.join(' ').split(' ').each do |name|
  #     set << name if set.exclude?(name)
  #   end
  #   set.join(' ')
  # end

  # def element_name(name)
  #   name_set = name.to_s.underscore.split('_')
  #   name_set.count >= 4 ? name_set.join('-') : name_set.join(' ')
  # end

  # def format_attr(name, *n)
  #   i = n.empty? ? 0 : n.first
  #   name_set = name.to_s.underscore.split('_')
  #   name_set.count >= i ? name_set.join('-') : name_set.join(' ')
  # end
  #kill
  # def format_opt_name(opt_grp, opt_grp_set)
  #   [format_attr(opt_grp), format_attr(opt_grp_set)].join('-')
  # end
end
