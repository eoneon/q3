module CategoriesHelper
  def pop_cat_items
    origin = find_or_create_by_name(:category, 'Origin')
    prod_cat_origin = find_or_create_by_name_and_assoc(origin, :category, 'Product-Category')
    pop_prod_cat_items(prod_cat_origin)
    #refactor starts here
    opt_group_origin = find_or_create_by_name_and_assoc(origin, :category, 'Option-Group')
    #pop_sig_opt_groups(opt_group_origin)
    build_opt_groups(origin)
  end

  def pop_prod_cat_items(origin)
    cat_assocs.each do |assoc_arr|
      prod_cat = find_or_create_by_name_and_assoc(origin, :category, assoc_arr.first)
      assoc_arr.drop(1).each do |prod_subcat_name|
        prod_subcat = find_or_create_by_name_and_assoc(prod_cat, :category, prod_subcat_name)
        pop_pp_items(prod_subcat)
      end
    end
  end

  ############################ start of refactor
  def build_opt_groups(origin)
    ['SubMedium', 'Edition', 'Signature', 'Certificate'].each do |sti|
      sti_key = to_snake(sti)
      #=> 'signature'
      nested_origin_name = [sti, origin.name].join('-')
      #['Signature', 'Option-Group'].join('-')
      #=> 'Signature-Option-Group'
      nested_origin = find_or_create_by_name_and_assoc(origin, :category, nested_origin_name)
      #Category(name: 'Option-Group') << nested_origin/'Signature-Option-Group'
      pop_nested_opt_groups?(nested_origin, sti_key)
    end
  end

  def pop_nested_opt_groups?(origin, sti_key)
    #if nested_opt_names = has_category_hash_key?(sti_key)
    if sti_opt_group(sti_key, :category).present?
      pop_nested_opt_groups(origin, sti_key)
    else
      #refac pt 1
      #keys = {sti_key: sti_key}
      #pop_opts(origin, keys)
      pop_opts(origin, sti_key, nil)
    end
  end

  #test for: pop_nested_opt_groups?
  def has_category_hash_key?(sti_scope)
    if sti_opt_group(sti_scope: sti_scope, :category).present?
      sti_opt_group(sti_scope: sti_scope, :category)
    end
  end

  def pop_nested_opt_groups(origin, sti_key)
    sti_opt_group(sti_key, :category).each do |cat_name|
      nested_origin_name = [cat_name, origin.name].join('-')
      nested_origin = find_or_create_by_name_and_assoc(origin, :category, nested_origin_name)
      #origin << #Category(name: 'Flat-Signature-Option-Group')
      #refac pt 2
      #keys = {sti_key: sti_key, assoc_key: cat_name}
      #pop_opts(nested_origin, keys)
      pop_opts(nested_origin, sti_key, cat_name)
      #Category(name: 'Flat-Signature-Option-Group'), "signature", 'Flat-Signature'
    end
  end
  ##refac pt 3
  #pop_opts(origin, keys)
  def pop_opts(origin, sti_key, *assoc_key)
    #refac pt 4
    #opt_names = sti_opt_group(sti_key, keys)
    opt_names = sti_opt_group(sti_key, :opts, assoc_key)
    #refac pt 5
    #opts = opt_names.map {|opt_name| find_or_create_by_name(keys[sti_key], opt_name)}
    opts = opt_names.map {|opt_name| find_or_create_by_name(sti_key, opt_name)}

    #refac pt 6
    #sti_opt_group(sti_key, keys).empty?
    if sti_opt_group(sti_key, :opt_idx).empty?
      assoc_kollection(origin, opts)
    else
      #refac pt 7
      pop_nested_opt_group_via_opt_idx(origin, sti_key, assoc_key, opts)
    end
  end
  ############################ end of refactor
  #redundant
  # def pop_sig_opt_groups(origin)
  #   sti = 'Signature'
  #   opt_group_origin = find_or_create_by_name_and_assoc(origin, :category, append_name(sti, 'Option-Group'))
  #   ['Flat', 'Sculpture'].each do |cat|
  #     assoc_key = append_name(cat, sti)
  #     name = append_name(assoc_key, 'Option-Group')
  #     sig_opt_group = find_or_create_by_name_and_assoc(opt_group_origin, :category, name)
  #     pop_sig_items(sig_opt_group, assoc_key)
  #   end
  # end
  #redundant
  # def pop_sig_items(sig_opt_group, assoc_key)
  #   sig_pps =[]
  #   pp_hash(:signature, assoc_key).each do |sig_pp_name|
  #     #sig_pps << find_or_create_by_name_and_assoc(sig_opt_group, :signature, sig_pp_name)
  #     sig_pps << find_or_create_by_name(:signature, sig_pp_name)
  #   end
  #   pop_opt_groups(sig_opt_group, :category, :signature, assoc_key, sig_pps)
  # end

  def pop_pp_items(prod_subcat)
    assoc_key = prod_subcat.name #'Flat-ProductKind'
    sti_key = :"#{to_snake(assoc_key.split('-').last)}"
    pp_hash(sti_key, assoc_key).each do |pp_name|
      pp = find_or_create_by_name_and_assoc(prod_subcat, sti_key, pp_name)
      #ProductKind(name: 'original-art')
      #Category(name: 'Flat-ProductKind') << #ProductKind(name: 'original-art')
      if sti_key == :product_kind
        pop_sub_pp_items(pp, :medium)
      elsif sti_key == :mounting && pp.name != 'wrapped'
        pop_mount_dim_items(pp, :dimension)
      end
    end
  end
  #compare
  def pop_sub_pp_items(pp, sti_key)
    assoc_key = pp.name
    pp_hash(sti_key, assoc_key).each do |sub_pp_name|
      sub_pp = find_or_create_by_name_and_assoc(pp, sti_key, sub_pp_name)
    end
  end

  def pop_mount_dim_items(mounting_pp, sti_key)
    dim_pp = find_or_create_by_name_and_assoc(mounting_pp, sti_key, append_name(mounting_pp.name, sti_key.to_s))
  end

  #A: redundant
  # def pop_opt_groups(parent, hm_assoc, nested_hm_assoc, assoc_key, sti_obj_set)
  #   sti_opt_idx = option_group(nested_hm_assoc, assoc_key) #.flatten(1)
  #   sti_opt_group_set = sti_opt_idx.map {|idx_set| idx_set.map {|idx| sti_obj_set[idx]}}
  #   compare_parent_and_sti_opt_group_sets(parent, hm_assoc, nested_hm_assoc, sti_opt_group_set)
  # end

  def pop_nested_opt_group_via_opt_idx(origin, sti_key, assoc_key, opt_names)
    opt_idx = sti_opt_group(sti_key, :opt_idx)
    opt_set = opt_idx.map {|idx_set| idx_set.map {|idx| opt_names[idx]}}
    compare_parent_and_sti_opt_group_sets(origin, :category, sti_key, opt_set)
  end

  #B
  def compare_parent_and_sti_opt_group_sets(parent, hm_assoc, nested_hm_assoc, sti_opt_group_set)
    if parent_opt_groups = has_kollection?(parent, hm_assoc)
      parent_opt_group_set = parent_opt_groups.map {|parent_opt_group| has_kollection?(parent_opt_group, nested_hm_assoc).to_a}
      missing_opt_groups = sti_opt_group_set.select {|subset| parent_opt_group_set.exclude?(subset)}

      #missing_opt_groups = sti_opt_group_set - parent_opt_group_set
      #puts "#{missing_opt_groups} #{parent_opt_group_set}"
      if missing_opt_groups.any?
        pop_missing_opt_groups(parent, hm_assoc, nested_hm_assoc, missing_opt_groups)
      end
    else
      pop_missing_opt_groups(parent, hm_assoc, nested_hm_assoc, sti_opt_group_set)
    end
  end

  #C
  def pop_missing_opt_groups(parent, hm_assoc, nested_hm_assoc, missing_opt_groups)
    #puts "#{missing_opt_groups}"
    missing_opt_groups.each do |opt_group|
      name = arr_to_text(opt_group.map {|opt| opt.name})
      #puts "opt_group: #{opt_group}"
      #nested_parent = to_konstant(hm_assoc).create(name: arr_to_text(name))
      nested_parent = find_or_create_by_name_and_assoc(parent, hm_assoc, name)
      opt_group.map {|opt| to_kollection(parent, nested_hm_assoc) << opt}
      #opt_group.map {|opt| to_kollection(nested_parent, nested_hm_assoc) << opt}
      #assoc_kollection(opt_group, nested_parent, nested_hm_assoc)
    end
  end

  # def assoc_opts_to_group(opts, parent, hm_assoc)
  #   #test =[]
  #   opts.each do |opt|
  #     to_kollection(parent, hm_assoc) << opt
  #     test << opt.name
  #   end
  #   #{}"WTF test: #{test.join(' & ')}"
  # end

  ##################### end of refactor
  #replaces: :assoc_opts_to_group
  def assoc_kollection(origin, target_type, targets)
    to_kollection(origin, target_type) << targets
  end

  def find_or_create_by_name_and_assoc(origin, target_type, target_name)
    target = find_or_create_by_name(target_type, target_name)
    associate_unless_included(origin, target)
    return target
  end

  def find_or_create_by_name(klass, name)
    to_konstant(klass).where(name: name).first_or_create
  end

  def associate_unless_included(origin, target)
    to_kollection(origin, target) << target unless to_kollection(origin, target).include?(target)
  end

  #####################

  def classified_types(type)
    self_join_assocs(type).map {|t| to_classify(t)}
  end

  def sti_product_parts(sti_key, sti_name)
    flat_art, sericel, sculpture = ['Flat-Art', 'original art', 'one-of-a-kind art', 'limited edition', 'print-media'], ['Sericels', 'production-sericel', 'limited edition', 'sericel'], ['Sculptures', 'hand-blown glass', 'hand-made ceramic', 'limited-edition', 'generic sculptures']
    h = {product_kind: [flat_art, sericel, sculpture]}
    h[:"#{sti_key}"].assoc(sti_name).drop(1)
  end

  def append_name(sti, suffix)
    [sti, suffix].join('-')
  end

#############

  def category_origin(obj)
    types = classified_types('category')
    name = to_classify(obj.name)
    name_or_get_parent(obj, types, name)
  end

  def name_or_get_parent(obj, types, name)
    if types.include?(name)
      name
    else
      get_parent(obj, types, name)
    end
  end

  def get_parent(obj, types, name)
    parent = ItemGroup.where(target_id: obj.id, target_type: 'Category').first
    name_or_get_parent(parent, types, parent.name)
  end

end
