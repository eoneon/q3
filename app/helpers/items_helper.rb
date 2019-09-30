module ItemsHelper
  def build_app_data
    build_opts
    build_products_and_product_kinds
    assoc_material_dimension_mounting
    assoc_medium_edition
    build_opt_groups
    assoc_medium_submedia
  end

  ################################################################## build_opts

  def build_opts
    sti_opts.each do |sti|
      public_send(sti + '_names').each do |name|                  #names
        obj = find_or_create_by_name(obj_klass: sti, name: name)
        update_tags(obj, build_tags(sti, name))
      end
    end
  end

  def build_products_and_product_kinds
    [['product_kind', [:medium]], ['product', [:product_kind, :medium]]].each do |obj_set|
      build_product_items(obj_set[0], obj_set[1])
    end
  end

  def assoc_material_dimension_mounting
    materials, dimensions, mountings = Material.all, Dimension.all, Mounting.all
    ['two-d', 'three-d'].each do |tag|
      scoped_materials = materials.where("tags @> ?", ("dimension_type => #{tag}"))
      scoped_dimensions = dimensions.where("tags @> ?", ("#{to_snake(tag)} => true"))
      scoped_mountings = mountings.where("tags @> ?", ("#{to_snake(tag)} => true"))
      assoc_origins_and_target_set(origins: scoped_materials, targets: scoped_dimensions)
      assoc_origins_and_target_set(origins: scoped_materials, targets: scoped_mountings)
      assoc_origins_and_target_set(origins: scoped_mountings, targets: scoped_dimensions)
    end
  end

  def assoc_medium_edition
    edition_types = assoc_keys(scoped_edition_types)
    editions = Edition.all
    media = Medium.where(name: edition_types)
    edition_types.each do |edition_type|
      medium = media.find_by(name: edition_type)
      targets = editions.where("tags @> ?", ("edition_type => #{edition_type}"))
      assoc_targets(origin: medium, targets: targets)
    end
  end

  def build_opt_groups
    origin = find_or_create_by_name(obj_klass: :option_group, name: 'secondary-medium-option')
    set = build_secondary_medium_set
    if nested_origins = has_kollection?(origin, :option_group)
      #existing_set = nested_origins.map {|nested_origin| nested_origin.media.to_a}
      existing_set = existing_scoped_targets_set(nested_origins, [:medium])
      create_missing_and_assoc_opt_with_targets(origin, set, existing_set)
    else
      create_all_and_assoc_opts_with_targets(origin, set)
    end
  end

  def assoc_medium_submedia
    print = Medium.find_by(name: 'print')
    option_group = OptionGroup.find_by(name: 'secondary-medium-option')
    has_kollection?(option_group, :option_group).map{|opt_group| assoc_unless_included(print, opt_group)}
  end

  ########################################################### refactored build_product_kinds

  def build_product_items(sti, target_types)
    set = build_grouped_set(sti)
    if existing_set = existing_set_and_update_tags(sti, target_types)
      create_missing_and_assoc_targets(sti, set, existing_set)
    else
      create_all_and_assoc_targets(set, sti)
    end
  end

  def build_grouped_set(sti)
    public_send(sti + '_grouped_set')
  end

  ###########################################################

  def product_kind_grouped_set
    primary_media = Medium.where("tags @> ?", ("medium_type => primary"))
    set =[]
    product_kind_medium_set.each do |medium_set|
      set << medium_set.map {|medium_name| primary_media.find_by(name: medium_name)}
    end
    set
  end

  def product_grouped_set
    set, materials =[], Material.all
    ProductKind.all.each do |pk|
      if assoc = pk.tags["material_assoc"]
        materials.where("tags @> ?", ("medium_assoc => #{assoc}")).map {|material| set << [pk, material]}
      end
    end
    set
  end

  ###########################################################

  def existing_set_and_update_tags(sti, target_types)
    existing_set =[]
    to_konstant(sti).all.each do |obj|
      target_set = target_types.map {|target_type| has_kollection?(obj, target_type).to_a}.flatten
      existing_set << target_set
      sti_key = "#{sti}_tags".to_sym
      if tags_hash.has_key?(sti_key)
        sti_tags = public_send(sti_key)
        build_nested_tags(target_set.map(&:name), sti_tags, obj)
      end
    end
    existing_set
  end

  def build_nested_tags(name_set, scoped_hash, obj)
    scoped_hash.keys.each do |k|
      value_sets = scoped_hash[k]
      tags_hsh ={} #medium_group_hsh
      name_set.each do |name|
        v = tag_filter(set: value_sets, k: k, name: name)
        if v.any?
          hsh = {"#{k.to_s}" => v.first} #medium_hsh
          tags_hsh.merge!(hsh)
        end
      end
      update_tags(obj, tags_hsh)
    end
  end

  def tag_filter(set:, k:, name:)
    set.map {|value_set| value_set[0] if value_set.include?(name) }.reject {|i| i.nil?}
  end

  def create_missing_and_assoc_targets(sti, set, existing_set)
    set.each do |target_set|
      if existing_set.exclude?(target_set)
        create_and_assoc_targets(sti, target_set)
      end
    end
  end

  def create_all_and_assoc_targets(set, sti)
    set.each do |target_set|
      create_and_assoc_targets(sti, target_set)
    end
  end

  def create_and_assoc_targets(sti, target_set)
    name_set = target_set.map(&:name)
    name = format_obj_name(sti, name_set)
    obj = find_or_create_by_name(obj_klass: sti, name: name)
    unless sti == 'product'
      build_nested_tags(name_set, public_send(sti + '_tags'), obj)
    end
    target_set.map {|target| assoc_unless_included(obj, target)}
  end

  def format_obj_name(sti, name_set)
    if sti == 'product'
      format_product_material_name(name_set)
    elsif sti == 'product_kind'
      name_set.join(' ')
    end
  end

  def format_product_material_name(name_set)
    name_split = name_set.join(' ').split(' ')
    if name_split.include?('sericel')
      name_split.delete_at(name_split.rindex('sericel'))
      name_split.join(' ')
    elsif name_split.include?('sculpture')
      name_split.delete_at(name_split.rindex('sculpture'))
      name_split.push('sculpture').join(' ')
    elsif include_any?(name_split, ['hand-made', 'hand-blown'])
      name_split.push('sculpture').join(' ')
    else
      name_set.join(' on ')
    end
  end

  ########################################################### opt-group
  def build_signature_and_certificate
    [option_group_hash.merge(two_d_standard), option_group_hash.merge(three_d_standard), option_group_hash.merge(two_d_sericel)].each do |h|
      sti, name, tags, target_types, set = h[:sti], h[:name], to_tags_hash(h[:target_types], h[:target_type_tags]), h[:target_type_tags], h[:set]
      origin = find_or_create_by_name(obj_klass: sti, name: name)
      update_tags(origin, tags)
      if nested_origins = has_kollection?(origin, sti)
        existing_set = existing_scoped_targets_set(sti, nested_origins, target_types, tags)
        create_missing_and_assoc_opt_with_targets(origin, set, existing_set)
      else
        create_all_and_assoc_opts_with_targets(origin, set)
      end
    end
  end

  def existing_scoped_targets_set(sti, origins, target_types, tags)
    existing_set =[]
    origins.each do |origin|
      target_set = target_types.map {|type| has_kollection?(origin, type).to_a.flatten}
      existing_set << target_set
    end
    existing_set
  end

  def to_tags_hash(target_types, tag_values)
    [target_types.map {|type| "#{type.to_s}_type"}, tag_values].transpose.to_h
  end

  def build_signature_and_certificate_subset(scoped_signature_set, scoped_certificate_set)
    set =[]
    scoped_certificate_set.each do |certificate_set|
      scoped_signature_set.each do |signature_set|
        set << [signature_set, certificate_set].flatten
      end
    end
    #set.concat(scoped_signature_set.map{|signature| [signature]}).concat(scoped_certificate_set.map{|certificate| [certificate]})
    set #.concat(scoped_signature_set.map{|signature| [signature]}).concat(scoped_certificate_set.map{|certificate| [certificate]})
  end

  def create_missing_and_assoc_opt_with_targets(origin, set, existing_set)
    set.each do |opt_set|
      if existing_set.exclude?(opt_set)
        create_opts_and_assoc_targets(origin, opt_set)
      end
    end
  end

  def create_all_and_assoc_opts_with_targets(origin, set)
    set.each do |opt_set|
      create_opts_and_assoc_targets(origin, opt_set)
    end
  end

  def create_opts_and_assoc_targets(origin, opt_set)
    name_set = opt_set.map(&:name)
    name = arr_to_text(name_set)
    opt_group =  find_or_create_by_name_and_assoc(origin: origin, target_type: :option_group, target_name: name)
    opt_set.map {|opt| assoc_unless_included(opt_group, opt)}
  end

  ###########################################################

  def build_secondary_medium_set
    media = Medium.where(name: secondary_media)
    opt_idx = [[0], [1], [0, 1]]
    build_idxd_set_of_target_groups(opts: media, opt_idx: opt_idx)
  end

  def build_idxd_set_of_target_groups(opts:, opt_idx:)
    opt_idx.map {|idx_set| idx_set.map {|idx| opts[idx]}}
  end

  ########################################################### hash & :tags methods

  def build_tags(sti, name)
    tags_hsh, sti_tag_hsh = {}, tags_hash[:"#{sti}_tags"]    #tags_hsh={}, sti_tag_hsh = tags_hash[:medium_tags]
    sti_tag_hsh.keys.each do |k|                             #=> [:medium_type, :material_type]
      v = tag_conditions(h: sti_tag_hsh, k: k, name: name)
      tags_hsh[k.to_s] = v unless v.nil?
    end
    tags_hsh
  end

  def tag_conditions(h:, k:, name:)
    h[k].each do |set|                    #sti_tag_hsh[:medium_tags][k] => #[['primary',...]]
      next if set.exclude?(name)
      return set[0]
    end
    nil
  end

  def update_tags(obj, tags)
    if obj.tags != tags
      obj.tags = tags
      obj.save
    end
  end

  def update_hash(h:, h2:, k:, v:)
    if k_exists_v_mismatch?(h: h, h2: h2, k: k, v: v) || kv_none?(h: h, h2: h2, k: k, v: v)
      h.merge!(h2)
    else
      h2
    end
  end

  def k_exists_v_match?(h:, h2:, k:, v:)
    h && h.present? && h.has_key?(k) && h[k] == v
  end

  def k_exists_v_mismatch?(h:, h2:, k:, v:)
    h && h.has_key?(k) && h[k] != v
  end

  def kv_none?(h:, h2:, k:, v:)
    h && !h.has_key?(k)
  end

  def assoc_keys(nested_arr)
    nested_arr.map {|set| set[0]}
  end
  ##################################################################

  # def assign_tags(obj, h2)
  #   h2.keys do |k|
  #     next if k_exists_v_match?(h: obj.tags, h2: h2, k: k, v: h2[k])
  #     obj.tags = update_hash(h: obj.tags, h2: h2, k: k, v: h2[k])
  #     obj.save
  #   end
  # end
end
