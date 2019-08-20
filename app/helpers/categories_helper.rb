module CategoriesHelper
  def pop_cat_items
    origin = find_or_create_by_name(obj_klass: :category, name: 'Origin')
    prod_cat_origin = find_or_create_by_name_and_assoc(origin: origin, target_type: :category, target_name: 'Product-Category')
    pop_prod_cat_items(prod_cat_origin)
    opt_group_origin = find_or_create_by_name_and_assoc(origin: origin, target_type: :category, target_name: 'Option-Group')
    build_opt_group_tree(opt_group_origin)
  end

  def pop_prod_cat_items(origin)
    cat_assocs.each do |assoc_arr|
      prod_cat = find_or_create_by_name_and_assoc(origin: origin, target_type: :category, target_name: assoc_arr.first)
      assoc_arr.drop(1).each do |prod_subcat_name|
        prod_subcat = find_or_create_by_name_and_assoc(origin: prod_cat, target_type: :category, target_name: prod_subcat_name)
        pop_pp_items(prod_subcat)
      end
    end
  end

  def pop_pp_items(prod_subcat)
    assoc_key = prod_subcat.name #'Flat-ProductKind'
    sti_key = :"#{to_snake(assoc_key.split('-').last)}"
    pp_hash(sti_key, assoc_key).each do |pp_name|
      pp = find_or_create_by_name_and_assoc(origin: prod_subcat, target_type: sti_key, target_name: pp_name)
      if sti_key == :product_kind
        pop_sub_pp_items(pp, :medium)
      elsif sti_key == :mounting && pp.name != 'wrapped'
        pop_mount_dim_items(pp, :dimension)
      end
    end
  end

  def pop_sub_pp_items(pp, sti_key)
    assoc_key = pp.name
    pp_hash(sti_key, assoc_key).each do |sub_pp_name|
      sub_pp = find_or_create_by_name_and_assoc(origin: pp, target_type: sti_key, target_name: sub_pp_name)
    end
  end

  def pop_mount_dim_items(mounting_pp, sti_key)
    dim_pp = find_or_create_by_name_and_assoc(origin: mounting_pp, target_type: sti_key, target_name: append_name(mounting_pp.name, sti_key.to_s))
  end

  #####################################################

  def build_opt_group_tree(origin)
    ['SubMedium', 'Edition', 'Signature', 'Certificate'].each do |sti|
      sti_key = to_snake(sti)
      nested_origin = build_nested_origin(origin: origin, target_type: :category, target_name: append_name(sti, origin.name)) #Category(name: 'Option-Group') << Cateory(name: STI-Option-Group)
      build_nested_opt_groups(origin: nested_origin, sti_scope: sti_key)
    end
  end

  def build_nested_opt_groups(origin:, sti_scope:)
    h = scoped_opt_groups(sti_scope: sti_scope).compact
    if h.include?(:category) && h.include?(:opt_idx)
      build_nested_cats_and_opt_groups_scoped_by_opt_idxs(origin: origin, sti_key: sti_scope, nested_origin_names: h[:category], opt_names: h[:opts], opt_idx: h[:opt_idx])
    elsif h.exclude?(:category) && h.include?(:opt_idx)
      build_opt_groups_scoped_by_opt_idxs(origin: origin, sti_key: sti_scope, opt_names: h[:opts], opt_idx: h[:opt_idx])
    elsif h.exclude?(:category) && h.exclude?(:opt_idx)
      find_or_create_by_names_and_assoc(origin: origin, target_type: sti_scope, target_names: h[:opts])
    end
  end

  def build_nested_cats_and_opt_groups_scoped_by_opt_idxs(origin:, sti_key:, nested_origin_names:, opt_names:, opt_idx:)
    nested_origin_names.each do |nested_origin_name| #'Flat-Signature'
      nested_origin = build_nested_origin(origin: origin, target_type: :category, target_name: append_name(nested_origin_name, 'Option-Group')) #'Flat-Signature-Option-Group'
      opts = find_or_create_by_names(obj_klass: sti_key, names: opt_names.assoc(nested_origin_name).drop(1))
      all_idxd_target_groups = build_idxd_set_of_target_groups(opts: opts, opt_idx: opt_idx.assoc(nested_origin_name).drop(1))

      build_target_groups_with_idxd_targets(origin: nested_origin, target_type: :category, nested_target_type: sti_key, all_idxd_target_groups: all_idxd_target_groups)
    end
  end

  def build_opt_groups_scoped_by_opt_idxs(origin:, sti_key:, opt_names:, opt_idx:)
    opts = find_or_create_by_names(obj_klass: sti_key, names: opt_names)
    all_idxd_target_groups = build_idxd_set_of_target_groups(opts: opts, opt_idx: opt_idx)
    build_target_groups_with_idxd_targets(origin: origin, target_type: :category, nested_target_type: sti_key, all_idxd_target_groups: all_idxd_target_groups)
  end

  #####################################################

  def build_idxd_set_of_target_groups(opts:, opt_idx:)
    opt_idx.map {|idx_set| idx_set.map {|idx| opts[idx]}}
  end

  def build_target_groups_with_idxd_targets(origin:, target_type:, nested_target_type:, all_idxd_target_groups:)
    if missing_target_groups = missing_target_groups?(origin, target_type, nested_target_type, all_idxd_target_groups)
      build_missing_target_groups(origin: origin, target_type: target_type, nested_target_type: nested_target_type, missing_target_groups: missing_target_groups)
    end
  end

  def missing_target_groups?(origin, target_type, nested_target_type, all_idxd_target_groups)
    if target_group_id_set = target_group_id_set?(origin, target_type, nested_target_type)
      if missing_target_groups = find_missing_target_groups(all_idxd_target_groups, target_group_id_set)
        missing_target_groups
      end
    else
      all_idxd_target_groups
    end
  end

  def target_group_id_set?(origin, target_type, nested_target_type)
    if nested_origins = has_kollection?(origin, target_type)
      target_group_id_set = nested_origins.map {|nested_origin| has_kollection_ids?(nested_origin, nested_target_type)}
      target_group_id_set if target_group_id_set.any?
    end
  end

  def find_missing_target_groups(all_idxd_target_groups, target_group_id_set)
    missing_target_groups =[]
    all_idxd_target_groups.each do |idxd_target_group|
      idxd_target_group_ids = idxd_target_group.map {|target| target.id}
      missing_target_groups << idxd_target_group if target_group_id_set.exclude?(idxd_target_group_ids)
    end
    return missing_target_groups if missing_target_groups.any?
  end

  def build_missing_target_groups(origin:, target_type:, nested_target_type:, missing_target_groups:)
    missing_target_groups.each do |target_group|
      target_group_origin = find_or_create_by_name_and_assoc(origin: origin, target_type: target_type, target_name: arr_to_text(target_group.map {|target| target.name}))
      if !has_kollection?(target_group_origin, nested_target_type)
        target_group.map {|target| to_kollection(target_group_origin, nested_target_type) << target}
      end
    end
  end

  def build_idxd_set_of_target_group(sti_key:, target_set:, assoc_key:)
    opt_idx = scoped_opt_groups(sti_scope: sti_key, hash_key: :opt_idx, assoc_key: assoc_key)
    opt_idx.map {|idx_set| idx_set.map {|idx| target_set[idx]}}
  end

  def build_nested_origin(origin:, target_type:, target_name:)
    find_or_create_by_name_and_assoc(origin: origin, target_type: target_type, target_name: target_name)
  end

  #####################################################

  def find_or_create_by_name(obj_klass:, name:)
    to_konstant(obj_klass).where(name: name).first_or_create
  end

  def find_or_create_by_names(obj_klass:, names:)
    objs = []
    names.each do |name|
      objs << find_or_create_by_name(obj_klass: obj_klass, name: name)
    end
    return objs
  end

  def find_or_create_by_name_and_assoc(origin:, target_type:, target_name:)
    target = find_or_create_by_name(obj_klass: target_type, name: target_name)
    assoc_unless_included(origin, target)
    return target
  end

  def find_or_create_by_names_and_assoc(origin:, target_type:, target_names:)
    targets =[]
    target_names.each do |target_name|
      target = find_or_create_by_name(obj_klass: target_type, name: target_name)
      targets << target
      assoc_unless_included(origin, target)
    end
    return targets
  end

  def assoc_unless_included(origin, target)
    to_kollection(origin, target) << target unless to_kollection(origin, target).include?(target)
  end

  def assoc_kollection(origin:, target_type:, targets:)
    to_kollection(origin, target_type) << targets
    targets.map {|target| to_kollection(origin, target_type) << target}
  end

  def has_kollection_ids?(origin, target_type)
    if kollection = has_kollection?(origin, target_type)
      kollection.pluck(:id)
    end
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
