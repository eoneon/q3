module ItemsHelper

  ##################################################################  tags_hash methods
  def sti_opts
    ['medium', 'material', 'edition', 'signature', 'dimension', 'mounting']
  end

  def tags_hash
    h = {medium_tags: medium_hash, material_tags: material_hash, edition_tags: edition_hash, signature_tags: signature_hash, dimension_tags: dimension_hash, mounting_tags: mounting_hash, certificate_type: certificate_hash}
  end

  ##############################

  def medium_hash
    h = {medium_type: scoped_medium_types, material_type: scoped_medium_material_types}
  end

  def material_hash
    h = {material_type: scoped_medium_material_types, dimension_tags: scoped_material_dimension_types}
  end

  def edition_hash
    h = {edition_type: scoped_edition_types}
  end

  def signature_hash
    h = {signature_type: scoped_signature_types}
  end

  def dimension_hash
    h = {dimension_type: scoped_dimension_types}
  end

  def mounting_hash
    h = {mounting_type: scoped_mounting_dimension_types}
  end

  def certificate_hash
    h = {certificate_type: scoped_certificate_types}
  end

  ##############################

  def scoped_medium_types
    [primary_media.prepend('primary'), secondary_media.prepend('secondary'), component_media.prepend('component')]
  end

  def scoped_medium_material_types
    [flat_art.prepend('flat'), photo_art, sericel_art, sculpture_art, hand_blown_art]
  end

  def scoped_material_dimension_types
    [two_d_materials.prepend('true'), three_d_materials.prepend('true')]
  end

  def scoped_edition_types
    [limited_edition.prepend('limited-edition'), open_edition, single_edition]
  end

  def scoped_signature_types
    [flat_signatures.prepend('two-d'), sculpture_signatures.prepend('three-d')]
  end

  def scoped_dimension_types
    [two_dimensions.prepend('two-d'), three_dimensions.prepend('three-d')]
  end

  def scoped_mounting_dimension_types
    [two_dimension_mountings.prepend('two-d'), three_dimension_mountings.prepend('three-d')]
  end

  def scoped_certificate_types
    [basic_certificates.prepend('basic_coa'), publisher_certificates.prepend('publisher_coa'), animation_certificates.prepend('animation_coa')]
  end

  ################################################################## build_opts

  def build_opts
    ['medium', 'material', 'edition', 'signature', 'dimension', 'mounting'].each do |sti|
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
      if set.include?(name)               #set => ['primary',...]
        return set[0]
      end
    end
  end

  def update_tags(obj, tags)
    if obj.tags != tags
      obj.tags = tags
      obj.save
    end
  end

  # def assign_tags(obj, h2)
  #   "prekeys_loop: #{h2}"
  #   h2.keys do |k|
  #     puts "keys_loop: #{k}"
  #     next if k_exists_v_match?(h: obj.tags, h2: h2, k: k, v: h2[k])
  #     obj.tags = update_hash(h: obj.tags, h2: h2, k: k, v: h2[k])
  #     obj.save
  #   end
  # end

  ##################################################################  tag_hashs methods

  # def tag_hash
  #   h ={
  #     medium_tags: ['primary', 'secondary', 'material_type'],
  #     material_tags: material_tags.concat(dimension_tags),
  #     edition_tags: ['limited-edition', 'single-edition', 'open-edition'],
  #     signature_tags: dimension_tags,
  #     dimension_tags: dimension_tags,
  #     mounting_tags:  dimension_tags,
  #     certificate_tags:  ['basic_coa', 'pubisher_coa', 'animation_coa'],
  #     product_kind_tags: dimension_tags
  #     }
  # end
  #
  # def dimension_tags
  #   ['two-d', 'three-d']
  # end
  #
  # def material_tags
  #   ['flat', 'photography', 'sericel', 'hand-made', 'hand-blown', 'sculpture']
  # end
  #
  # def boolean_tags(tag_set)
  #   tag_set.select {|k| to_snake(k).split('_').last != 'type'}
  # end
  #
  # def type_tags(tag_set)
  #   tag_set.select {|k| to_snake(k).split('_').last == 'type'}
  # end

  # def medium_boolean_conditions(name)
  #   [primary_media.prepend('primary'), secondary_media.prepend('secondary'), component_media.prepend('component')].each do |set|
  #     if set.include?(name)
  #       return set[0]
  #     end
  #   end
  # end
  #
  # def medium_type_conditions(name)
  #   [flat_art.prepend('flat'), photo_art, sericel_art, sculpture_art, hand_blown_art].each do |set|
  #     if set.include?(name)
  #       return ['material_type', set[0]]
  #     end
  #   end
  # end

  ##################################################################

  # def build_opts
  #   ['medium', 'material', 'edition', 'signature', 'dimension', 'mounting'].each do |sti_name|
  #     obj_names = public_send(sti_name + '_names')
  #     build_objs_and_set_tags(sti_name, obj_names)
  #   end
  # end
  #
  # def build_objs_and_set_tags(sti_name, obj_names)
  #   obj_names.each do |obj_name|
  #     obj = find_or_create_by_name(obj_klass: sti_name, name: obj_name)
  #     #tag_set = tag_hash[:"#{sti_name}_tags"]
  #     tags = public_send(sti_name + '_tag_conditions', obj_name).map {|i| to_snake(i)}
  #     tags_hash_arr = tags.map {|k| h = {k => 'true'}}
  #     set_tags(obj, tags_hash_arr)
  #   end
  # end
  #
  # def set_tags(obj, tags_hash_arr)
  #   tags_hash_arr.each do |h2|
  #     k = h2.keys.first
  #     next if k_exists_v_match?(h: obj.tags, h2: h2, k: k, v: h2[k])
  #     obj.tags = update_hash(h: obj.tags, h2: h2, k: k, v: h2[k])
  #     obj.save
  #   end
  # end

  ##################################################################

  # def signature_opts
  #   [
  #     ['artist', [:dimension_tags, ['two_d', 'three_d']]],
  #     ['authorized', [:dimension_tags, ['two_d']]],
  #     ['relative', [:dimension_tags, ['two_d']]],
  #     ['famous', [:dimension_tags, ['two_d']]]
  #   ]
  # end
  #
  # def build_signature_opts
  #   signature_opts.each do |sig_opt|
  #     name = sig_opt[0]  #'artist'
  #     obj = find_or_create_by_name(obj_klass: :signature, name: name)
  #     tag_set = sig_opt[1]  #['dimension_tags', ['two_d', 'three_d']
  #     tag_keys.each do |k,v|
  #       if tag_set.include?(k) #k = 'dimension_tags'
  #         arr_of_hashes = v.map {|opt| h = {opt => 'true'} if tag_set[1].include?(opt)}.reject {|i| i.nil?}
  #         arr_of_hashes.each do |h2|
  #           k = h2.keys.first
  #           next if k_exists_v_match?(h: obj.tags, h2: h2, k: k, v: h2[k])
  #           obj.tags = update_hash(h: obj.tags, h2: h2, k: k, v: h2[k])
  #           obj.save
  #         end
  #       end
  #     end
  #   end
  # end

  ################################################################## test

  # def flat_signatures
  #   ['artist', 'authorized', 'relative', 'famous']
  # end
  #
  # def sculpture_signatures
  #   ['artist']
  # end
  #
  # def signature_names
  #   flat_signatures | sculpture_signatures
  # end

  # def signature_opts
  #   set =[]
  #   signature_names.each do |name|
  #     if sculpture_signatures.include?(name)
  #       tags = ['two-d', 'three-d']
  #     else
  #       tags = ['two-d']
  #     end
  #     set << [name, [:dimension_tags, tags]]
  #   end
  #   set
  # end

  ##################################################################

  def build_medium_types
    build_obj_from_sets(medium_type, 'medium_type', :medium)
    build_obj_from_sets(material_types, 'material_type', :material)
    add_material_tags
    assoc_material_dimension_mounting
    build_obj_from_sets(edition_types, 'edition_type', :edition)
    assoc_medium_edition
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

  ########################################################### medium name sets & conditions

  def medium_names
    primary_media | secondary_media | component_media
  end

  def primary_media
    ['original', 'painting', 'drawing', 'production', 'one-of-a-kind', 'mixed-media', 'limited-edition', 'embellished', 'single-edition', 'open-edition', 'print', 'hand-pulled', 'hand-made', 'hand-blown', 'photography', 'sculpture', 'sculpture-type', 'animation', 'sericel']
  end

  def secondary_media
    ['leafing', 'remarque']
  end

  def component_media
    ['diptych', 'triptych', 'quadriptych', 'set']
  end

  def flat_art
    ['original', 'one-of-a-kind', 'print']
  end

  def photo_art
    ['photography']
  end

  def sericel_art
    ['sericel']
  end

  def sculpture_art
    ['sculpture']
  end

  def hand_blown_art
    ['hand-blown']
  end

  def hand_made_art
    ['hand-made']
  end
  ################## medium conditions

  # def medium_tag_conditions(name)
  #   if primary_media.include?(name)
  #     ['primary']
  #   elsif secondary_media.include?(name)
  #     ['secondary']
  #   elsif component_media.include?(name)
  #     ['component']
  #   end
  # end

  ########################################################### material name sets

  def material_names
    flat_materials | photography_materials | sericel_materials | sculpture_materials | hand_blown_materials | hand_made_materials
  end

  def two_d_materials
    flat_materials | photography_materials | sericel_materials
  end

  def three_d_materials
    sculpture_materials | hand_blown_materials | hand_made_materials
  end

  def flat_materials
    ['canvas', 'paper', 'board']
  end

  def photography_materials
    ['photography-paper']
  end

  def sericel_materials
    ['sericel', 'sericel with background']
  end

  def sculpture_materials
    ['metal', 'glass', 'mixed-media','ceramic']
  end

  def hand_blown_materials
    ['glass']
  end

  def hand_made_materials
    ['ceramic']
  end

  ################## material conditions

  # def material_tag_conditions(name)
  #   [material_type_tags(name), material_dimension_type_tags(name)]
  # end
  #
  # def material_type_tags(name)
  #   case
  #   when flat_materials.include?(name) then 'flat'
  #   when photography_materials.include?(name) then 'photography'
  #   when sericel_materials.include?(name) then 'sericel'
  #   when sculpture_materials.include?(name) then 'sculpture'
  #   when hand_blown_materials.include?(name) then 'hand-blown'
  #   when hand_made_materials.include?(name) then 'hand-made'
  #   end
  # end
  #
  # def material_dimension_type_tags(name)
  #   if sculpture_art_type.include?(name)
  #     'three-d'
  #   else
  #     'two-d'
  #   end
  # end

  def sculpture_art_type
    ['sculpture', 'hand-blown', 'hand-made']
  end

  ########################################################### edition name sets

  def edition_names
    limited_edition | open_edition | single_edition
  end

  def limited_edition
    ['numbered-xy', 'numbered', 'from-an-edition']
  end

  def open_edition
    ['open-edition']
  end

  def single_edition
    ['single-edition']
  end

  ################## edition conditions

  # def edition_tag_conditions(name)
  #   case
  #   when limited_edition.include?(name) then ['limited-edition']
  #   when open_edition.include?(name) then ['open-edition']
  #   when single_edition.include?(name) then ['single-edition']
  #   end
  # end

  ########################################################### signature name sets

  def signature_names
    flat_signatures | sculpture_signatures
  end

  def flat_signatures
    ['artist', 'authorized', 'relative', 'famous']
  end

  def sculpture_signatures
    ['artist']
  end

  ################## signature conditions

  # def signature_tag_conditions(name)
  #   if sculpture_signatures.include?(name)
  #     ['two-d', 'three-d']
  #   else
  #     ['two-d']
  #   end
  # end

  ########################################################### dimension & mounting name sets

  def dimension_names
    two_dimensions | three_dimensions
  end

  def two_dimensions
    ['width', 'height']
  end

  def three_dimensions
    ['width', 'height', 'depth']
  end

  def mounting_names
    two_dimension_mountings | three_dimension_mountings
  end

  def two_dimension_mountings
    ['framed', 'bordered', 'matted']
  end

  def three_dimension_mountings
    ['case', 'base']
  end

  # def dimension_tag_conditions(name)
  #   if two_dimensions.include?(name) && three_dimensions.include?(name)
  #     ['two-d', 'three-d']
  #   else
  #     ['two-d']
  #   end
  # end
  #
  # def mounting_tag_conditions(name)
  #   if three_dimensions.include?(name)
  #     ['three-d']
  #   else
  #     ['two-d']
  #   end
  # end

  ########################################################### certificate name sets

  def certificate_names
    basic_certificates | publisher_certificates | animation_certificates
  end

  def basic_certificates
    ['basic-certificate']
  end

  def publisher_certificates
    ['publisher-certificate']
  end

  def animation_certificates
    ['animation-seal', 'sports-seal', 'animation-certificate', 'basic-certificate']
  end

  def certificate_tag_conditions(name)
    ["#{name.split('-').first }_coa"]
  end
  # def medium_type
  #   [primary_media, secondary_media, component_media]
  # end
  #
  # def primary_media
  #   ['primary', 'original', 'painting', 'drawing', 'production', 'one-of-a-kind', 'mixed-media', 'limited-edition', 'embellished', 'single-edition', 'open-edition', 'print', 'hand-pulled', 'hand-made', 'hand-blown', 'photography', 'sculpture', 'sculpture-type', 'animation', 'sericel']
  # end
  #
  # def secondary_media
  #   ['secondary', 'leafing', 'remarque']
  # end
  #
  # def component_media
  #   ['diptych', 'triptych', 'quadriptych', 'set']
  # end

  # def material_types
  #   [
  #     ['flat', 'canvas', 'paper', 'board'],
  #     ['photography', 'photography-paper'],
  #     ['sericel', 'sericel', 'sericel with background'],
  #     ['sculpture', 'metal', 'glass', 'mixed-media','ceramic'],
  #     ['hand-blown', 'glass'],
  #     ['hand-made', 'ceramic']
  #   ]
  # end

  # def dimension_types
  #   [['two-d', 'width', 'height'], ['three-d', 'width', 'depth', 'height']]
  # end

  # def mounting_types
  #   [['two-d', 'framed', 'bordered', 'matted'], ['three-d', 'case', 'base']]
  # end

  # def edition_types
  #   [
  #     ['limited-edition', 'numbered-xy', 'numbered', 'from-an-edition'],
  #     ['open-edition', 'open-edition'],
  #     ['single-edition', 'numbered 1/1']
  #   ]
  # end

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

  def assoc_keys(nested_arr)
    nested_arr.map {|set| set[0]}
  end
end
