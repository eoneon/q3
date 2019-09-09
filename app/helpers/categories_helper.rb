module CategoriesHelper

  def build_app_data
    origin = find_or_create_by_name(obj_klass: :category, name: 'Origin')
    ['Product-Category', 'Option-Group', 'Medium-Group', 'Identifier-Group'].each do |name|
      nested_origin = find_or_create_by_name_and_assoc(origin: origin, target_type: :category, target_name: name)
      public_send('build_' + to_snake(name), nested_origin)
    end
  end

  ####################################### build_identifier_group: origin = Category(name: 'Identifier-Group')

  def build_identifier_group(origin)
    h, cert_identifiers = {}, opt_group_values(certificate_opt_group)
    #identifier_pks.map {|arr| h[build_key(arr[0])] = ProductKind.where(name: arr.drop(1)).to_a}
    opt_group_values(signature_opt_group).map {|key| h[build_key(key)] = Category.find_by(name: append_name(key, 'Option-Group'))}
    cert_identifiers.map {|key| h[build_key(key)] = Category.find_by(name: append_name(key, 'Option-Group'))}
    set = identifiers(h)
    build_scoped_identifier_groups(origin, set)
  end

  ####################################### utility methods for build_identifier_group

  #scoped_identifier_set
  def identifiers(h)
    identifier_set, flat_signature, sculpture_signature, cert_identifiers = {}, h['flat_signature'], h['sculpture_signature'], opt_group_values(certificate_opt_group).map {|key| h[build_key(key)]}
    identifier_set['flat_product_kind'] = build_identifier_set(cert_identifiers.take(2), flat_signature)
    identifier_set['sculpture_product_kind'] = build_identifier_set(cert_identifiers.take(2), sculpture_signature)
    identifier_set['sericel_product_kind'] = build_identifier_set(cert_identifiers, flat_signature)
    identifier_set
  end

  def build_identifier_set(certs, signature)
    groups = single_identifiers(certs, signature)
    double_identifiers = double_identifiers(certs, signature, groups)
  end

  def single_identifiers(certs, signature)
    groups = []
    certs.each do |cert|
      groups << [cert]
    end
    groups.prepend([signature])
  end

  def double_identifiers(certs, signature, groups)
    certs.reverse.each do |cert|
      groups.prepend([signature, cert])
    end
    groups
  end

  def build_key(key)
    key.split('-').map {|k| to_snake(k)}.join('_')
  end

  ####################################### Medium-Group III

  def build_medium_group(origin)
    flat_items.push(sculpture_items).flatten.each do |key|
      nested_origin = find_or_create_by_name_and_assoc(origin: origin, target_type: :medium_group, target_name: append_name(key, 'Medium-Group'))
      ################# A
      set = build_medium_group_set(key)

      if nested_medium_groups = has_kollection?(nested_origin, :medium_group)
        existing_set = nested_medium_groups.map {|medium_group| hashified_type_eql_id_via_assocs(obj: medium_group, assocs: medium_group_types)}
        ################# B
        build_medium_group_combos(origin: nested_origin, existing_set: existing_set, set: set)
      else
        build_missing_medium_groups(origin: nested_origin, target_type: :medium_group, target_group_set: set)
      end
    end
  end

  def build_scoped_identifier_groups(origin, set) #origin = Category(name: 'Identifier-Group')
    opt_group_values(identifier_pks).each do |key|
      nested_origin = find_or_create_by_name_and_assoc(origin: origin, target_type: :identifier_group, target_name: append_name(key, 'Identifier-Group')) #IdentifierGroup(name: 'Flat-ProductKind-Identifier-Group')
      if nested_sub_origins = has_kollection?(nested_origin, :identifier_group)
        existing_set = nested_sub_origins.map {|obj| type_and_id_assoc_arr(obj_set: to_kollection(obj, :category)) if has_kollection?(obj, :category)}
          ################# B
        build_identifier_group_combos(origin: nested_origin, existing_set: existing_set, set: set[build_key(key)])
      else
        build_missing_identifier_groups(origin: nested_origin, target_type: :identifier_group, target_group_set: set[build_key(key)])
      end
      origin_names = identifier_pks.assoc(key).drop(1)
      assoc_target_and_origins_via_name_set(origin_klass: :product_kind, origin_names: origin_names, target: nested_origin)
    end
  end

  # def format_nested_sub_kollection(nested_sub_origin)
  #   if nested_identifier_groups = has_kollection?(nested_sub_origin, :identifier_group)
  #     nested_identifier_groups.map {|identifier_group| type_and_id_assoc_arr(obj_set: identifier_group)}
  #   end
  # end
  ##################################################### utility methods for :build_medium_group

  ################# A: build_medium_group_values

  def build_medium_group_set(key)
    pk_sets = build_product_kind_sets(key) #A(1)
    pk_medium_items = pk_sets.map {|pk| [pk[0], has_kollection?(pk[-1], 'medium').to_a]}
    pk_medium_set = pk_medium_items.map {|items| items[1].map {|medium| [items[0], medium]}}.flatten(1)
    material_set = find_origin_kollection_by_name(origin_name: append_name(key, 'Material'), origin_type: :category, target_type: 'Material').to_a
    pk_medium_set.map {|pk_medium| material_set.map {|material| [pk_medium[0], pk_medium[1], material]}}.flatten(1)
  end

  ################# A(1)

  def build_product_kind_sets(key)
    product_kinds = find_origin_kollection_by_name(origin_name: append_name(key, 'ProductKind'), origin_type: :category, target_type: 'ProductKind')
    ################# A(2)
    product_kinds.map {|pk| product_kind_set(pk)}
  end

  ################# A(2)

  def product_kind_set(pk)
    if pk2 = has_obj?(pk, 'product_kind')
      [pk,pk2]
    else
      [pk]
    end
  end

  ##################################################### utility methods for :medium_group_target_sets

  ##################################################### B

  def build_medium_group_combos(origin:, set:, existing_set:)
    ################# B(1)
    if missing_medium_groups = find_missing_targets(set: set, existing_set: existing_set)
      ################# B(2)
      build_missing_medium_groups(origin: origin, target_type: :medium_group, target_group_set: missing_medium_groups)
    end
  end

  def build_identifier_group_combos(origin:, set:, existing_set:)
    ################# B(1)
    if missing_identifier_groups = find_missing_identifiers(set: set, existing_set: existing_set)
      ################# B(2)
      build_missing_identifier_groups(origin: origin, target_type: :identifier_group, target_group_set: missing_identifier_groups)
    end
  end
  ##################################################### B(1)

  def find_missing_targets(set:, existing_set:)
    excluded_set =[]
    set.each do |obj_set|
      hashified_obj_set = hashified_type_eql_id_via_obj_set(obj_set: obj_set)
      if existing_set.exclude?(hashified_obj_set)
        excluded_set << obj_set
      end
    end
    return excluded_set if excluded_set.any?
  end
  ##################################################### B(1) for identifiers: should replace above
  def find_missing_identifiers(set:, existing_set:)
    excluded_set =[]
    set.each do |obj_set|
      assoc_arr_obj_set = type_and_id_assoc_arr(obj_set: obj_set) #hashified_type_eql_id_via_obj_set(obj_set: obj_set)
      if existing_set.exclude?(assoc_arr_obj_set)
        excluded_set << obj_set
      end
    end
    return excluded_set if excluded_set.any?
  end

  ##################################################### hash methods for :find_missing_targets

  def hashified_type_eql_id_via_obj_set(obj_set:)
    h = {}
    obj_set.map {|obj| h[to_snake(obj.type)] = obj.id}
  end

  def type_and_id_assoc_arr(obj_set:)
    obj_set.map {|obj| [to_snake(obj.type), obj.id]}
  end

  def hashified_type_eql_id_via_assocs(obj:, assocs:)
    h = {}
    assocs.map {|assoc| h[assoc] = has_obj?(obj, assoc).id}
  end

  ##################################################### only difference between following methods is the format_name method so conflate

  def build_missing_medium_groups(origin:, target_type:, target_group_set:)
    target_group_set.each do |target_set|
      nested_origin = find_or_create_by_name_and_assoc(origin: origin, target_type: target_type, target_name: medium_group_name(target_set))
      push_missing_targets_via_obj_set(origin: nested_origin, obj_set: target_set)
    end
  end

  def build_missing_identifier_groups(origin:, target_type:, target_group_set:)
    target_group_set.each do |target_set|
      nested_origin = find_or_create_by_name_and_assoc(origin: origin, target_type: target_type, target_name: identifier_group_name(target_set))
      push_missing_targets_via_obj_set(origin: nested_origin, obj_set: target_set)
    end
  end

  ##################################################### utility methods for :build_missing_medium_groups

  def push_missing_targets_via_obj_set(origin:, obj_set:)
    obj_set.map {|obj| to_kollection(origin, obj.type) << obj if !has_obj?(origin, obj.type)}
  end

  ####################################### Product-Category I

  def build_product_category(origin)
    cat_assocs.each do |assoc_arr|
      prod_cat = find_or_create_by_name_and_assoc(origin: origin, target_type: :category, target_name: assoc_arr.first)
      assoc_arr.drop(1).each do |prod_subcat_name|
        prod_subcat = find_or_create_by_name_and_assoc(origin: prod_cat, target_type: :category, target_name: prod_subcat_name)
        pop_pp_items(prod_subcat)
      end
    end
    assoc_material_to_mountings_and_dimensions
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

  def assoc_material_to_mountings_and_dimensions
    flat_items.concat(sculpture_items).each do |item|
      origin = find_or_create_by_name(obj_klass: :category, name: append_name(item, 'Material'))
      target_names = origin.name.split('-').include?('Sculpture') ? sculpture_mount_dim_items : flat_mount_dim_items
      set = target_names.map {|name| [:category, name]}
      assoc_nested_origins_and_target_set(origin: origin, hm_assoc: :material, target_set: set)
    end
  end
  ##################################################### Option-Group II

  def build_option_group(origin)
    ['SubMedium', 'Edition', 'Signature', 'Certificate'].each do |sti|
      sti_key = to_snake(sti)
      nested_origin = build_nested_origin(origin: origin, target_type: :category, target_name: append_name(sti, origin.name)) #Category(name: 'Option-Group') << Cateory(name: STI-Option-Group)
      build_nested_opt_groups(origin: nested_origin, sti_scope: sti_key)
    end
    build_limited
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

  def build_limited
    limited_pk.each do |arr|
      origin = find_or_create_by_name(obj_klass: :category, name: arr[0])
      nested_origin = find_or_create_by_name_and_assoc(origin: origin, target_type: :product_kind, target_name: append_name('Limited Edition', arr[-1]))
      find_or_create_by_name_and_assoc(origin: nested_origin, target_type: :category, target_name: 'Edition-Option-Group')
      find_or_create_by_name_and_assoc(origin: nested_origin, target_type: :product_kind, target_name: arr[-1])
    end
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

  ##################################################### association utility methods

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

  def assoc_target_and_origins_via_name_set(origin_klass:, origin_names:, target:)
    origin_set = find_or_create_by_names(obj_klass: origin_klass, names: origin_names)
    origin_set.map {|origin| assoc_unless_included(origin, target)}
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

  def find_or_create_by_name_and_assoc_many(origins:, target_type:, target_name:)
    target = find_or_create_by_name(obj_klass: target_type, name: target_name)
    origins.map {|origin| assoc_unless_included(origin, target)}
    return target
  end

  def find_origin_kollection_by_name(origin_name:, origin_type:, target_type:)
    origin = find_or_create_by_name(obj_klass: origin_type, name: origin_name)
    has_kollection?(origin, target_type)
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

  #new
  def assoc_nested_origins_and_target_set(origin:, hm_assoc:, target_set:)
    target_set.each do |set|
      target = find_or_create_by_name(obj_klass: set[0], name: set[1])
      #Category(name: 'Flat-Material').materials
      to_kollection(origin, hm_assoc).map {|nested_origin| assoc_unless_included(nested_origin, target)}
    end
  end

  ##################################################### random utility methods

  def medium_group_types
    ['product_kind', 'medium', 'material']
  end

  def medium_group_name(target_set)
    target_set.map {|target| format_medium_group_name(target)}.reject {|i| i.nil?}.join(" ")
  end

  def format_medium_group_name(target)
    if target.type == 'ProductKind'
      target.name.split(" ").reject {|word| ['prints', 'print-media', 'art'].include?(word)}.join(" ")
    elsif target.type == 'Material'
      "on #{target.name}"
    else
      target.name
    end
  end

  ##################################################### new for identifier_group

  def identifier_group_name(target_set)
    target_set.map {|target| format_identifier_group_name(target)}.reject {|i| i.nil?}.join(" ")
  end

  def format_identifier_group_name(target)
    name_arr = target.name.split('-').take(2)
    if name_arr.include?('Signature')
      "Signed (#{name_arr[0]})"
    elsif name_arr.include?('Certificate')
      "with #{name_arr.join(' ')}"
    end
  end

  ##################################################### previous utility methods

  def classified_types(type)
    self_join_assocs(type).map {|t| to_classify(t)}
  end

  def sti_product_parts(sti_key, sti_name)
    flat_art, sericel, sculpture = ['Flat-Art', 'original art', 'one-of-a-kind art', 'limited edition', 'print-media'], ['Sericels', 'production-sericel', 'limited edition', 'sericel'], ['Sculptures', 'hand-blown glass', 'hand-made ceramic', 'limited-edition', 'generic sculptures']
    h = {product_kind: [flat_art, sericel, sculpture]}
    h[:"#{sti_key}"].assoc(sti_name).drop(1)
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
