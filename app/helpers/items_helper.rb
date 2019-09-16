module ItemsHelper
  def build_medium_types
    build_obj_from_sets(medium_type, 'medium_type', :medium)
    build_obj_from_sets(material_types, 'material_type', :material)
    add_material_tags
    assoc_material_dimension_mounting
    build_obj_from_sets(edition_types, 'edition_type', :edition)
    assoc_medium_edition
    #build_obj_from_sets(sub_medium_types, 'sub_medium_type', :edition)
    build_pk_medium_combos
    add_product_kind_tags
    build_product_combos
    build_secondary_medium_set
    assoc_medium_submedia
  end

  def build_obj_from_sets(obj_set, k, obj_klass)
    obj_set.each do |set|
      h, k, v = {}, k, set[0]
      h[k] = v
      set.drop(1).each do |obj_name|
        obj = find_or_create_by_name(obj_klass: obj_klass, name: obj_name)
        next if k_exists_v_match?(h: obj.tags, h2: h, k: k, v: v)
        obj.tags = update_hash(h: obj.tags, h2: h, k: k, v: v)
        obj.save
      end
    end
  end

  def add_material_tags
    materials = Material.all
    assoc_keys = assoc_keys(material_types)
    i = assoc_keys.index('sculpture')
    [assoc_keys[0...i].prepend('two-d'), assoc_keys[i..-1].prepend('three-d')].each do |set|
      tag = set[0]
      scoped_assoc_keys = set.drop(1)
      scoped_names = scoped_assoc_keys.map {|key| material_types.assoc(key)}.flatten
      materials.where(name: scoped_names).each do |material|
        h, k, v, tags = {}, 'dimension_type', tag, material.tags
        h[k] = v
        next if k_exists_v_match?(h: tags, h2: h, k: k, v: v)
        material.tags = update_hash(h: tags, h2: h, k: :k, v: v )
        material.save
      end
    end
  end

  def assoc_material_dimension_mounting
    materials = Material.all
    ['two-d', 'three-d'].each do |tag|
      materials.where("tags @> ?", ("dimension_type => #{tag}")).each do |material|
        find_or_create_by_names_and_assoc(origin: material, target_type: :dimension, target_names: dimension_types.assoc(tag).drop(1))
        find_or_create_by_names_and_assoc(origin: material, target_type: :mounting, target_names: mounting_types.assoc(tag).drop(1))
      end
    end
  end

  def assoc_medium_edition
    assoc_keys = assoc_keys(edition_types)
    media = Medium.where(name: assoc_keys)
    assoc_keys.each do |tag|
      medium = media.find_by(name: tag)
      find_or_create_by_names_and_assoc(origin: medium, target_type: :edition, target_names: edition_types.assoc(tag).drop(1))
    end
  end

  ###########################################################

  def build_product_combos
    set = build_product_combo_set
    if Product.any?
      existing_set = Product.all.map {|p| [:product_kind, :material].map{|target_type| has_obj?(p, target_type)}.flatten}
      add_missing_product_combos(set, existing_set)
    else
      add_all_product_combos(set)
    end
  end

  def build_product_combo_set
    set =[]
    ProductKind.all.each do |pk|
      Material.where(name: material_types.assoc(pk.tags['material_type'])).map {|material| set << [pk, material]}
    end
    set
  end

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

  def add_product_kind_tags
    ProductKind.all.each do |pk|
      name_set = pk.media.map(&:name)
      h = build_product_kind_tags(target_names: name_set) #A
      if pk.tags != h
        pk.tags = set_product_kind_tags(pk.tags, h) #B
        pk.save
      end
    end
  end

  #B
  def set_product_kind_tags(tags, h)
    if tags.present?
      update_pk_tags(tags, h) #C
    else
      h
    end
  end

  def update_pk_tags(tags, h) #C
    h.keys.each do |k|
      next if k_exists_v_match?(h: tags, h2: h, k: k, v: h[k])
      update_hash(h: tags, h2: h, k: k, v: h[k])
    end
  end

  ###########################################################

  #A
  def build_product_kind_tags(target_names:)
    h ={}
    h['dimension_type'] = set_dimention_type(target_names)
    h['art_type'] = set_art_type(target_names)
    h['material_type'] = set_material_type(target_names)
    h
  end

  #A(1)
  def set_dimention_type(target_names)
    if include_any?(target_names, sculpture_art_type_set)
      'three-d'
    else
      'two-d'
    end
  end

  #A(2)
  def set_art_type(target_names)
    if include_any?(target_names, original_art_type_set) #A(1)(i)
      'original'
    elsif include_any?(target_names, sculpture_art_type_set)
      'sculpture'
    elsif target_names.include?('limited-edition') && include_any?(target_names, print_art_type_set) #A(1)(ii)
      'limited-edition'
    elsif exclude_all?(target_names, original_art_type_set.prepend('limited-edition')) && include_any?(target_names, print_art_type_set) #A(1)(ii) & (ii)
      'print'
    end
  end

  #A(3)
  def set_material_type(target_names)
    if include_any?(target_names, original_art_type_set.prepend('print'))
      'flat'
    elsif material = target_names.detect {|name| name if ['sericel', 'photography', 'hand-blown', 'hand-made', 'sculpture'].include?(name)}
      material
    end
  end

  #A(1)(i)
  def original_art_type_set
    ['original', 'one-of-a-kind']
  end

  #A(1)(ii)
  def print_art_type_set
    ['print', 'sericel', 'photography']
  end

  def sculpture_art_type_set
    ['sculpture', 'hand-blown', 'hand-made']
  end

  ###########################################################

  def update_hash(h:, h2:, k:, v:)
    if k_exists_v_mismatch?(h: h, h2: h2, k: k, v: v) || kv_none?(h: h, h2: h2, k: k, v: v)
      h.merge!(h2)
    else
      h2
    end
  end

  def build_pk_medium_combos
    set = build_pk_medium_combo_set
    if ProductKind.any?
      existing_set = ProductKind.all.map {|pk| pk.media.to_a}
      add_missing_pk_medium_combos(set, existing_set)
    else
      add_all_medium_combos(set)
    end
  end

  def add_missing_pk_medium_combos(set, existing_set)
    set.each do |medium_combo|
      if existing_set.exclude?(medium_combo)
        add_combos(medium_combo)
      end
    end
  end

  def add_all_medium_combos(set)
    set.each do |medium_combo|
      add_combos(medium_combo)
    end
  end

  def add_combos(medium_combo)
    name = medium_combo.map(&:name).join(' ')
    pk = find_or_create_by_name(obj_klass: :product_kind, name: name)
    medium_combo.map {|medium| assoc_unless_included(pk, medium)}
  end

  def build_pk_medium_combo_set
    primary_media = Medium.where("tags -> 'medium_type' = 'primary'")
    set =[]
    pk_medium_combo_set.each do |medium_combo|
      set << medium_combo.map {|medium_name| primary_media.find_by(name: medium_name)}
    end
    set
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
  
  ###########################################################

  def medium_type
    [primary_media, secondary_media, component_media]
  end

  def primary_media
    ['primary', 'original', 'painting', 'drawing', 'production', 'one-of-a-kind', 'mixed-media', 'limited-edition', 'embellished', 'single-edition', 'open-edition', 'print', 'hand-pulled', 'hand-made', 'hand-blown', 'photography', 'sculpture', 'sculpture-type', 'animation', 'sericel']
  end

  def secondary_media
    ['secondary', 'leafing', 'remarque']
  end

  def component_media
    ['diptych', 'triptych', 'quadriptych', 'set']
  end

  def material_types
    [
      ['flat', 'canvas', 'paper', 'board'],
      ['photography', 'photography-paper'],
      ['sericel', 'sericel', 'sericel with background'],
      ['sculpture', 'metal', 'glass', 'mixed-media','ceramic'],
      ['hand-blown', 'glass'],
      ['hand-made', 'ceramic']
    ]
  end

  def dimension_types
    [['two-d', 'width', 'height'], ['three-d', 'width', 'depth', 'height']]
  end

  def mounting_types
    [['two-d', 'framed', 'bordered', 'matted'], ['three-d', 'case', 'base']]
  end

  def edition_types
    [
      ['limited-edition', 'numbered-xy', 'numbered', 'from-an-edition'],
      ['open-edition', 'open-edition'],
      ['single-edition', 'numbered 1/1']
    ]
  end

  # def edition_types
  #   ['edition' ,'numbered-xy', 'numbered', 'from-an-edition', 'open-edition']
  # end

  def k_exists_v_match?(h:, h2:, k:, v:)
    h && h.present? && h.has_key?(k) && h[k] == v
  end

  def k_exists_v_mismatch?(h:, h2:, k:, v:)
    h && h.has_key?(k) && h[k] != v
  end

  def kv_none?(h:, h2:, k:, v:)
    h && !h.has_key?(k)
  end

  def pk_medium_combo_set
   [['original', 'painting'],
   ['original', 'drawing'],
   ['original', 'production', 'drawing'],
   ['original', 'production', 'sericel'],
   ['original', 'mixed-media'],
   ['one-of-a-kind', 'mixed-media'],
   ['embellished', 'one-of-a-kind', 'mixed-media'],
   ['single-edition', 'one-of-a-kind', 'mixed-media'],
   ['embellished', 'single-edition', 'one-of-a-kind', 'mixed-media'],
   ['one-of-a-kind', 'hand-pulled', 'print'],
   ['embellished', 'one-of-a-kind', 'hand-pulled', 'print'],
   ['single-edition', 'one-of-a-kind', 'hand-pulled', 'print'],
   ['embellished', 'single-edition', 'one-of-a-kind', 'hand-pulled', 'print'],
   ['print'],
   ['embellished', 'print'],
   ['single-edition', 'print'],
   ['hand-pulled', 'print'],
   ['open-edition', 'print'],
   ['photography'],
   ['limited-edition', 'print'],
   ['embellished', 'limited-edition', 'print'],
   ['limited-edition', 'hand-pulled', 'print'],
   ['single-edition', 'hand-pulled', 'print'],
   ['limited-edition', 'photography'],
   ['animation', 'sericel'],
   ['limited-edition', 'sericel'],
   ['hand-blown'],
   ['hand-made'],
   ['sculpture'],
   ['embellished', 'sculpture'],
   ['limited-edition', 'sculpture'],
   ['embellished', 'limited-edition', 'sculpture']]
  end

  # def pk_medium_combo_set
  #  [['original', 'painting'],
  #  ['original', 'drawing'],
  #  ['original', 'production', 'drawing'],
  #  ['original', 'production', 'sericel'],
  #  ['original', 'mixed-media'],
  #  ['one-of-a-kind', 'mixed-media'],
  #  ['single-edition', 'one-of-a-kind', 'mixed-media'],
  #  ['one-of-a-kind', 'hand-pulled', 'print'],
  #  ['single-edition', 'one-of-a-kind', 'hand-pulled', 'print'],
  #  ['print'],
  #  ['single-edition', 'print'],
  #  ['hand-pulled', 'print'],
  #  ['open-edition', 'print'],
  #  ['photography'],
  #  ['limited-edition', 'print'],
  #  ['limited-edition', 'hand-pulled', 'print'],
  #  ['single-edition', 'hand-pulled', 'print'],
  #  ['limited-edition', 'photography'],
  #  ['animation', 'sericel'],
  #  ['limited-edition', 'sericel'],
  #  ['sculpture'],
  #  ['hand-blown'],
  #  ['hand-made'],
  #  ['limited-edition', 'sculpture']]
  # end

  def assoc_keys(nested_arr)
    nested_arr.map {|set| set[0]}
  end
end
