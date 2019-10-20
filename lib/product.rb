module Product
  extend BuildSet

  def self.populate
    product_set = existing_set
    if product_set.any?
      create_missing(product_set)
    else
      create_all
    end
  end

  def self.existing_set
    set =[]
    Element.by_kind('product').each do |product|
      product_elements = product.elements
      update_tags(product, build_tags(product_elements.map(&:name)))
      set << product_elements if product_elements.any?
    end
    set
  end

  def self.create_missing(product_set)
    option_group_set.each do |target_set|
      if product_set.exclude?(target_set)
        build_obj(target_set)
      end
    end
  end

  def self.create_all
    option_group_set.each do |target_set|
      build_obj(target_set)
    end
  end

  def self.build_obj(target_set)
    name = format_name(target_set.map(&:name))
    product = find_or_create_by(kind: 'product', name: name)
    update_tags(product, build_tags(target_set.map(&:name)))
    target_set.map {|target| assoc_unless_included(origin: product, target: target)}
  end

  def self.format_name(name_set)
    if idx = name_set.index('sculpture')
      name_set[0..-2].insert(idx, name_set[-1]).join(' ')
    elsif name_set[-1] == 'sericel'
      name_set[0..-2].join(' ')
    else
      name_set.insert(-2, 'on').join(' ')
    end
  end
  #add material_tag
  def self.build_tags(name_set)
    tag_hsh ={}
    boolean_tag(name_set, tag_hsh)
    attr_tags(name_set, tag_hsh)
    tag_hsh
  end

  def self.option_group_set
    product_set =[]
    media = Element.by_kind('medium')
    materials = Element.by_kind('material')
    media_options.each do |media_set|
      media_group = media_set.map {|medium_name| media.where(name: medium_name).first}
      material_set = material_options(media_set)
      material_group = materials.where(name: material_set)
      material_group.map {|material| product_set << [media_group, material].flatten}
    end
    product_set
  end

  def self.material_options(name_set)
    if include_any?(name_set, %w[painting mixed-media print]) && name_set.exclude?('hand-pulled')
      %w[canvas paper board metal]
    elsif include_all?(%w[production drawing], name_set)
      'animation-paper'
    elsif name_set.include?('drawing') && name_set.exclude?('production')
      'drawing-paper'
    elsif name_set.include?('hand-pulled')
      'canvas'
    elsif name_set.include?('photography')
      'photography-paper'
    elsif name_set.include?('sericel')
      'sericel'
    elsif name_set.include?('hand-blown')
      'glass'
    elsif name_set.include?('hand-made')
      'ceramic'
    elsif name_set.include?('sculpture')
      %w[glass ceramic metal synthetic]
    end
  end

  def self.boolean_tag(name_set, tag_hsh)
    name_set.each do |name|
      tag_hsh.merge!(h={"#{name}" => "true"}) if boolean_tag_options.include?(name)
    end
    tag_hsh
  end

  def self.boolean_tag_options
    Medium::BooleanTag.new.primary + Medium::BooleanTag.new.category
  end

  def self.attr_tags(name_set, tag_hsh)
    if include_any?(name_set, %w[original one-of-a-kind])
      tag_hsh.merge!(h={'art_type' => "original", "art_category" => "original-painting"})
    elsif name_set.include?('limited-edition') && include_any?(name_set, %w[print sericel photography])
      tag_hsh.merge!(h={'art_type' => "limited-edition", "art_category" => "limited-edition"})
    elsif name_set.exclude?('limited-edition') && include_any?(name_set, %w[print sericel photography])
      tag_hsh.merge!(h={'art_type' => "print", "art_category" => "limited-edition"})
    elsif include_any?(name_set, %w[sculpture hand-made])
      tag_hsh.merge!(h={'art_type' => "sculpture", "art_category" => "sculpture"})
    elsif name_set.include?('hand-blown')
      tag_hsh.merge!(h={'art_type' => "sculpture", "art_category" => "hand-blown-glass"})
    end
  end

  def self.media_options
    [
      %w[original painting],
      %w[original drawing],
      %w[original production drawing],
      %w[original production sericel],
      %w[original mixed-media],
      %w[one-of-a-kind mixed-media],
      %w[embellished one-of-a-kind mixed-media],
      %w[single-edition one-of-a-kind mixed-media],
      %w[embellished single-edition one-of-a-kind mixed-media],
      %w[one-of-a-kind hand-pulled print],
      %w[embellished one-of-a-kind hand-pulled print],
      %w[single-edition one-of-a-kind hand-pulled print],
      %w[embellished single-edition one-of-a-kind hand-pulled print],
      %w[print],
      %w[embellished print],
      %w[single-edition print],
      %w[hand-pulled print],
      %w[open-edition print],
      %w[photography],
      %w[limited-edition print],
      %w[embellished limited-edition print],
      %w[limited-edition hand-pulled print],
      %w[embellished limited-edition hand-pulled print],
      %w[single-edition hand-pulled print],
      %w[limited-edition photography],
      %w[sericel],
      %w[limited-edition sericel],
      %w[hand-blown sculpture],
      %w[hand-made sculpture],
      %w[sculpture],
      %w[embellished sculpture],
      %w[limited-edition sculpture],
      %w[embellished limited-edition sculpture]
    ]
  end

  def self.search_dropdown
    [
      ['all products', 'products'],
      ['original paintings', 'painting'],
      ['one-of-a-kind mixed-media', 'one_of_a_kind_mixed_media'],
      ['one-of-a-kind mixed-media numbered 1/1', 'single_edition_one_of_a_kind_mixed_media'],
      ['production art', 'production'],
      ['drawings', 'drawing'],
      ['limited edition prints', 'limited_edition_prints'],
      ['hand-pulled prints', 'hand_pulled'],
      ['photography', 'photography'],
      ['prints', 'only_prints'],
      ['sericels', 'sericel'],
      ['hand-blown glass', 'hand_blown'],
      ['hand-made ceramic', 'hand_made'],
      ['sculptures', 'standard_sculptures'],
      ['limited edition sculptures', 'limited_edition_sculptures']
    ]
  end

end
