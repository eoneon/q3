module ItemTypesHelper
  def prod_cat_items
    ['Flat', 'Sericel', 'HB-Sculpture', 'HM-Sculpture', 'General-Sculpture']
  end

  def product_kind_sets
    set =[]
    prod_cat_items.each do |prod_cat|
      origin = find_or_create_by_name(obj_klass: :category, name: append_name(prod_cat, 'ProductKind'))
      pk_targets = has_kollection?(origin, 'product_kind')
      set << pk_targets.all.map {|pk| build_pk_group(pk)}
    end
    set
  end

  def pk_medium_material_sets
    sets =[]
    product_kind_sets.each do |pk_set|
      pk, pk2 = pk_set[0], pk_set[-1]
      media_material_sets = ['medium', 'material'].map {|type| obj_or_kollection?(pk2, type)}
      sets << [pk, media_material_sets] unless media_material_sets.compact.count < 2
    end
    sets
  end
  #
  # def product_kind_sets
  #   ProductKind.all.map {|pk| build_pk_group(pk)}
  # end
  #
  # def pk_medium_material_sets(set)
  #   sets =[]
  #   product_kind_sets.each do |set|
  #     pk, pk2 = set[0], set[-1]
  #     media_material_sets = ['media', 'material'].map {|type| obj_or_kollection?(pk2, type)}
  #     sets << [pk, media_material_sets] unless media_material_sets.compact.count < 2
  #   end
  #   sets
  # end

  def build_medium_group_params(sets)
    product_params =[]
    sets.each do |set|
      pk, media_set, material_set = set[0], set[1][0], set[1][1]
      pk_media = media_set.map {|media| [pk, media]}
      product_set(pk_media, material_set, product_params)
    end
    product_params
  end

  def populate_medium_groups(medium_group_sets)
    scoped_set = ItemGroup.where(origin_type: 'Product')
    medium_group_sets.each do |prxy_opt|
      unless origin_with_opt_exists?(scoped_set, prxy_opt)
        name = prxy_opt.map {|sub_obj| medium_group_name(sub_obj)}.reject {|i| i.nil?}.join(" ")
        product = Product.new(name: name)
        if product.save!
          prxy_opt.map {|sub_obj| to_kollection(product, sub_obj) << sub_obj}
        end
      end
    end
  end

  def origin_with_opt_exists?(scoped_set, prxy_opt)
    origin_id_sets = origin_id_sets(scoped_set, prxy_opt)
    intrsct = origin_id_sets[0] & origin_id_sets[1]
    if intrsct.count == 0
      false
    else
      origin_id_sets.drop(2).each do |subset|
        intrsct = subset & intrsct
        return false if intrsct.count == 0
      end
      intrsct
    end
  end

  def origin_id_sets(scoped_set, prxy_opt)
    prxy_opt.map {|sub_obj| scoped_set.where(target_id: sub_obj.id).pluck(:origin_id)}
  end

  def build_pk_group(pk)
    if pk2 = has_obj?(pk, 'product_kind')
      [pk,pk2]
    else
      [pk]
    end
  end

  def product_set(pk_media, material_set, product_params)
    pk_media.each do |set|
      material_set.each do |material|
        product_params << set.push(material)
        set = set.take(2)
      end
    end
  end

  def obj_or_kollection?(obj, type)
    if kollection = has_kollection?(obj, type)
      if kollection.count > 1
        #kollection.pluck(:name) #testing
        kollection
      elsif kollection.count == 1
        sub_obj = kollection.first
        if kollection = has_kollection?(sub_obj, type)
          #kollection.pluck(:name) #testing
          kollection
        else
          #sub_obj.class.name #testing
          sub_obj
        end
      end
    end
  end

  #commented out due to name collision: categories_helper
  # def medium_group_name(sub_obj)
  #   if sub_obj.type == 'ProductKind'
  #     sub_obj.name.split(" ").reject {|word| ['prints','art', 'print-media'].include?(word)}.join(" ")
  #   elsif sub_obj.type == 'Medium'
  #     sub_obj.name
  #   elsif sub_obj.type == 'Material'
  #     "on #{sub_obj.name}"
  #   end
  # end

  #type-specific nest collection
  # def has_sti_specific_sub_kollection?(obj)
  #   if sub_kollection = has_kollection?(obj, obj.class.name)
  #     sub_kollection
  #   end
  # end
end
