module ItemsHelper
  def build_medium_sets
    build_obj_from_sets(medium_set, 'medium_tier', :medium)
    build_obj_from_sets(material_types, 'material_type', :material)
    build_obj_from_sets(dimension_types, 'dimension_type', :dimension)
    build_obj_from_sets(mounting_types, 'mounting_type', :mounting)
    build_obj_from_sets(edition_types, 'edition_type', :edition)
    #build_obj_from_sets(sub_medium_types, 'sub_medium_type', :edition)
    build_pk_medium_combos
    add_product_kind_tags
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
      #assoc_key = pk.tags['material_type']
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
    name = product_combo.map(&:name).join(' on ')
    p = find_or_create_by_name(obj_klass: :product, name: name)
    product_combo.map {|obj| assoc_unless_included(p, obj)}
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
      #check_kv(h: tags, h2: h, k: k, v: h[k]) #D
    end
  end

  #D
  # def check_kv(h:, h2:, k:, v:)
  #   next if k_exists_v_match?(h: h, h2: h2, k: k, v: v)
  #   update_hash(h: h, h2: h2, k: k, v: v) #E
  # end

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
    target_names.include?('sculpture') ? 'three-d' : 'two-d'
  end

  #A(2)
  def set_art_type(target_names)
    if include_any?(target_names, original_art_type_set) #A(1)(i)
      'original'
    elsif target_names.include?('sculpture')
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
    elsif material = target_names.detect {|name| name if ['sericel', 'photography', 'hand-blown-glass', 'hand-made-ceramic'].include?(name)}
      material
    elsif exclude_all?(target_names, ['hand-blown-glass', 'hand-made-ceramic']) && target_names.include?('sculpture')
      'sculpture'
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
    primary_media = Medium.where("tags -> 'medium_tier' = 'primary'")
    set =[]
    pk_medium_combo_set.each do |medium_combo|
      set << medium_combo.map {|medium_name| primary_media.find_by(name: medium_name)}
    end
    set
  end

  def medium_set
    [primary_media, secondary_media, component_media]
  end

  def primary_media
    ['primary', 'original', 'painting', 'drawing', 'monoprint', 'production', 'one-of-a-kind', 'mixed-media', 'limited-edition', 'print', 'hand-pulled', 'hand-made-ceramic', 'hand-blown-glass', 'photography', 'sculpture', 'sculpture-type', 'animation', 'sericel']
  end

  def secondary_media
    ['secondary', 'embellishment', 'remarque']
  end

  def component_media
    ['diptych', 'triptych', 'quadriptych', 'set']
  end

  def material_types
    [['flat', 'canvas', 'paper', 'board'], ['photography', 'photography-paper'], ['sculpture', 'sculpture-materials'], ['sericel', 'sericel', 'sericel & background']]
  end

  def dimension_types
    [['two-d', 'width & height'], ['three-d', 'width, height & depth']]
  end

  def mounting_types
    [['two-d', 'framed', 'bordered', 'matted'], ['three-d', 'case', 'base']]
  end

  def edition_types
    ['edition' ,'numbered-xy', 'numbered', 'from-an-edition', 'open-edition']
  end
  #policies?
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
   ['original', 'monoprint'],
   ['one-of-a-kind', 'mixed-media'],
   ['one-of-a-kind', 'hand-pulled', 'print'],
   ['one-of-a-kind', 'monoprint'],
   ['print'],
   ['hand-pulled', 'print'],
   ['photography'],
   ['limited-edition', 'print'],
   ['limited-edition', 'hand-pulled', 'print'],
   ['limited-edition', 'photography'],
   ['animation', 'sericel'],
   ['limited-edition', 'sericel'],
   ['sculpture'],
   ['hand-blown-glass', 'sculpture'],
   ['hand-made-ceramic', 'sculpture'],
   ['limited-edition', 'sculpture']]
  end
end
