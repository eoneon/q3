module ItemsHelper

  ################################################################## build_opts

  def build_opts
    sti_opts.each do |sti|
      public_send(sti + '_names').each do |name|                  #names
        obj = find_or_create_by_name(obj_klass: sti, name: name)
        update_tags(obj, build_tags(sti, name))
      end
    end
  end

  def build_tags(sti, name)
    tags_hsh, sti_tag_hsh = {}, tags_hash[:"#{sti}_tags"]    #tags_hsh={}, sti_tag_hsh = tags_hash[:medium_tags]
    sti_tag_hsh.keys.each do |k|                             #=> [:medium_type, :material_type]
      tags_hsh[k.to_s] = tag_conditions(h: sti_tag_hsh, k: k, name: name)
    end
    tags_hsh
  end

  def tag_conditions(h:, k:, name:)
    h[k].each do |set|                    #sti_tag_hsh[:medium_tags][k] => #[['primary',...]]
      # if set.include?(name)               #set => ['primary',...]
      #   return set[0]
      # end
      next if set.exclude?(name)
      return set[0]
    end
  end

  def update_tags(obj, tags)
    if obj.tags != tags
      obj.tags = tags
      obj.save
    end
  end

  ###########################################################
  #build_products
  def build_product_combos
    set = build_product_combo_set
    if Product.any?
      existing_set = Product.all.map {|p| [:product_kind, :material].map{|target_type| has_obj?(p, target_type)}.flatten}
      add_missing_product_combos(set, existing_set)
    else
      add_all_product_combos(set)
    end
  end

  def build_products
    set = build_product_groups
    if Product.any?
      existing_set = existing_set_and_update_tags(:product, [:product_kind, :material])
      create_missing_and_assoc_targets(sti, set, existing_set)
    else
      create_all_and_assoc_targets(set, sti)
    end
  end

  # def build_product_combo_set
  #   set =[]
  #   ProductKind.all.each do |pk|
  #     Material.where(name: material_types.assoc(pk.tags['material_type'])).map {|material| set << [pk, material]}
  #   end
  #   set
  # end

  def add_missing_product_combos(set, existing_set)
    set.each do |product_combo|
      if existing_set.exclude?(product_combo)
        add_product_combos(product_combo)
      end
    end
  end

  def add_all_product_combos(set)
    set.each do |product_combo|
      add_product_combos(product_combo)
    end
  end

  def add_product_combos(product_combo)
    name_set = product_combo.map(&:name)
    name = format_product_material_name(name_set)
    p = find_or_create_by_name(obj_klass: :product, name: name)
    product_combo.map {|obj| assoc_unless_included(p, obj)}
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

  ###########################################################

  def update_hash(h:, h2:, k:, v:)
    if k_exists_v_mismatch?(h: h, h2: h2, k: k, v: v) || kv_none?(h: h, h2: h2, k: k, v: v)
      h.merge!(h2)
    else
      h2
    end
  end

  ########################################################### refactored build_product_kinds

  def build_product_kinds(sti, target_types)
    set = build_grouped_set(sti)
    if to_konstant(sti).any?
      existing_set = existing_set_and_update_tags(sti, target_types)
      #add_missing_pk_medium_combos(set, existing_set)
      create_missing_and_assoc_targets(sti, set, existing_set)
    else
      #add_all_medium_combos(set)
      create_all_and_assoc_targets(set, sti)
    end
  end

  def build_grouped_set(sti)
    public_send(sti.to_s + 'grouped_set')
  end

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
  # def existing_set_and_update_tags
  #   existing_set =[]
  #   ProductKind.all.map.each do |pk|
  #     #h, pk_media = {}, pk.media.to_a
  #     pk_media = pk.media.to_a
  #     existing_set << pk_media
  #     build_nested_tags(pk_media.map(&:name), product_kind_tags, pk)
  #   end
  #   existing_set
  # end

  def existing_set_and_update_tags(sti, target_types)
    existing_set =[]
    to_konstant(sti).all.each do |obj|
      target_set = target_types.map {|target_type| has_kollection?(obj, target_type).to_a}.flatten
      existing_set << target_set
      if sti_tags = public_send(sti.to_s + '_tags')
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

  # def add_missing_pk_medium_combos(set, existing_set)
  #   set.each do |medium_combo|
  #     if existing_set.exclude?(medium_combo)
  #       add_combos(medium_combo)
  #     end
  #   end
  # end

  # def add_all_medium_combos(set)
  #   set.each do |medium_combo|
  #     add_combos(medium_combo)
  #   end
  # end

  def create_all_and_assoc_targets(set, sti)
    set.each do |target_set|
      create_and_assoc_targets(sti, target_set)
    end
  end
  # def add_combos(medium_group)
  #   name_set = medium_group.map(&:name)
  #   name = name_set.join(' ')
  #   pk = find_or_create_by_name(obj_klass: :product_kind, name: name)
  #   scoped_hash = product_kind_tags
  #   build_nested_tags(name_set, scoped_hash, pk)
  #   medium_group.map {|medium| assoc_unless_included(pk, medium)}
  # end

  def create_and_assoc_targets(sti, target_set)
    name_set = target_set.map(&:name)
    name = format_obj_name(sti, name_set)
    obj = find_or_create_by_name(obj_klass: sti, name: name)
    if scoped_hash = public_send(sti.to_s + '_tags')
      build_nested_tags(name_set, scoped_hash, obj)
    end
    target_set.map {|target| assoc_unless_included(obj, target)}
  end

  def format_obj_name(sti, name_set)
    if sti == :product
      format_product_material_name(name_set)
    else
      name_set.join(' ')
    end
  end

  ########################################################### opt-group

  def build_secondary_medium_set
    origin = find_or_create_by_name(obj_klass: :option_group, name: 'submedia-option')
    set = build_secondary_medium_combo_set
    if nested_origins = has_kollection?(origin, :option_group)
      existing_set = nested_origins.map {|nested_origin| nested_origin.media.to_a}
      add_missing_secondary_medium_combos(origin, set, existing_set)
    else
      add_all_secondary_medium_combos(origin, set)
    end
    #origin
  end

  def build_secondary_medium_combo_set
    media = Medium.where(name: secondary_media)
    opt_idx = [[0], [1], [0, 1]]
    build_idxd_set_of_target_groups(opts: media, opt_idx: opt_idx)
  end

  def build_idxd_set_of_target_groups(opts:, opt_idx:)
    opt_idx.map {|idx_set| idx_set.map {|idx| opts[idx]}}
  end

  def add_missing_secondary_medium_combos(origin, set, existing_set)
    set.each do |submedium_combo|
      if existing_set.exclude?(submedium_combo)
        add_secondary_medium_combos(origin, submedium_combo)
      end
    end
  end

  def add_all_secondary_medium_combos(origin, set)
    set.each do |submedium_combo|
      add_secondary_medium_combos(origin, submedium_combo)
    end
  end

  def add_secondary_medium_combos(origin, submedium_combo)
    name_set = submedium_combo.map(&:name)
    name = arr_to_text(name_set)
    opt_group =  find_or_create_by_name_and_assoc(origin: origin, target_type: :option_group, target_name: name)
    submedium_combo.map {|target| assoc_unless_included(opt_group, target)}
  end

  def assoc_medium_submedia
    print = Medium.find_by(name: 'print')
    option_group = OptionGroup.find_by(name: 'submedia-option')
    has_kollection?(option_group, :option_group).map{|opt_group| assoc_unless_included(print, opt_group)}
  end

  ########################################################### medium name sets & conditions

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

  # def build_medium_types
  #   build_obj_from_sets(medium_type, 'medium_type', :medium)
  #   build_obj_from_sets(material_types, 'material_type', :material)
  #   add_material_tags
  #   assoc_material_dimension_mounting
  #   build_obj_from_sets(edition_types, 'edition_type', :edition)
  #   assoc_medium_edition
  #   build_pk_medium_combos
  #   add_product_kind_tags
  #   build_product_combos
  #   build_secondary_medium_set
  #   assoc_medium_submedia
  # end

  # def build_obj_from_sets(obj_set, k, obj_klass)
  #   obj_set.each do |set|
  #     h, k, v = {}, k, set[0]
  #     h[k] = v
  #     set.drop(1).each do |obj_name|
  #       obj = find_or_create_by_name(obj_klass: obj_klass, name: obj_name)
  #       next if k_exists_v_match?(h: obj.tags, h2: h, k: k, v: v)
  #       obj.tags = update_hash(h: obj.tags, h2: h, k: k, v: v)
  #       obj.save
  #     end
  #   end
  # end
  #
  # def add_material_tags
  #   materials = Material.all
  #   assoc_keys = assoc_keys(material_types)
  #   i = assoc_keys.index('sculpture')
  #   [assoc_keys[0...i].prepend('two-d'), assoc_keys[i..-1].prepend('three-d')].each do |set|
  #     tag = set[0]
  #     scoped_assoc_keys = set.drop(1)
  #     scoped_names = scoped_assoc_keys.map {|key| material_types.assoc(key)}.flatten
  #     materials.where(name: scoped_names).each do |material|
  #       h, k, v, tags = {}, 'dimension_type', tag, material.tags
  #       h[k] = v
  #       next if k_exists_v_match?(h: tags, h2: h, k: k, v: v)
  #       material.tags = update_hash(h: tags, h2: h, k: :k, v: v )
  #       material.save
  #     end
  #   end
  # end
  #
  # def assoc_material_dimension_mounting
  #   materials = Material.all
  #   ['two-d', 'three-d'].each do |tag|
  #     materials.where("tags @> ?", ("dimension_type => #{tag}")).each do |material|
  #       find_or_create_by_names_and_assoc(origin: material, target_type: :dimension, target_names: dimension_types.assoc(tag).drop(1))
  #       find_or_create_by_names_and_assoc(origin: material, target_type: :mounting, target_names: mounting_types.assoc(tag).drop(1))
  #     end
  #   end
  # end
  #
  # def assoc_medium_edition
  #   assoc_keys = assoc_keys(edition_types)
  #   media = Medium.where(name: assoc_keys)
  #   assoc_keys.each do |tag|
  #     medium = media.find_by(name: tag)
  #     find_or_create_by_names_and_assoc(origin: medium, target_type: :edition, target_names: edition_types.assoc(tag).drop(1))
  #   end
  # end
end
