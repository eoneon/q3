module CategoriesHelper
  def pop_sti_categories
    origin = find_or_create_by_name(:category, 'STI-Category')
    categories =[]
    self_join_assocs('category', :category).each do |type|
      category = find_or_create_by_name(:category, to_classify(type))
      associate_unless_included(origin, category)
      categories << category
    end
    pk = categories.select {|i| i.name == 'ProductKind'}.first
    pop_org_categories(pk, origin)
    #categories
  end

  #sti_category: Category(name: 'ProductKind')
  def pop_org_categories(sti_category, origin)
    structure = find_or_create_by_name(:category, 'Item-Category')
    associate_unless_included(origin, structure)
    sti_key = to_snake(sti_category.name)
    #['Flat-Category', 'Sericel-Category'...]
    org_categories.each do |cat_name|
      org_cat = find_or_create_by_name(:category, cat_name)
      #=> Category(name: 'Flat-Category', id: id)
      associate_unless_included(structure, org_cat)
      #Category(name: 'structure') << Category(name: 'Flat-Category')
      pop_item_structure(org_cat) #org_category: Category(name: 'Flat-Category')
    end
  end

  #org_category: Category(name: 'Flat-Category')
  def pop_item_structure(org_cat)
    assoc_key = org_cat.name #'Flat-Category'
    #['Flat-ProductKind', 'Flat-Material'...]
    org_elements(assoc_key).each do |subcat_name|
      sub_org_cat = find_or_create_by_name(:category, subcat_name)
      #=> Category(name: 'Flat-ProductKind', id: id)
      associate_unless_included(org_cat, sub_org_cat)
      #Category(name: 'Flat-Category') << Category(name: 'Flat-ProductKind')
      pop_pps(sub_org_cat) #Category(name: 'Flat-ProductKind')
    end
  end

  #here: org_cat #=> #Category(name: 'Flat-ProductKind')
  def pop_pps(org_cat)
    assoc_key = org_cat.name #'Flat-ProductKind'
    sti_key = :"#{to_snake(assoc_key.split('-').last)}"
    pp_hash(sti_key, assoc_key).each do |pp_name|
      pp = find_or_create_by_name(sti_key, pp_name)
      #ProductKind(name: 'original-art')
      associate_unless_included(org_cat, pp)
      #Category(name: 'Flat-ProductKind') << #ProductKind(name: 'original-art')
      if sti_key == :product_kind
        pop_sub_pps(pp, :medium)
      elsif sti_key == :mounting && pp.name != 'wrapped'
        pop_mountings_dimensions(pp, :dimension)
      end
    end
  end

  def pop_sub_pps(pp, sti_key)
    assoc_key = pp.name
    pp_hash(sti_key, assoc_key).each do |sub_pp_name|
      sub_pp = find_or_create_by_name(sti_key, sub_pp_name)
      associate_unless_included(pp, sub_pp)
    end
  end

  def pop_mountings_dimensions(mounting_pp, sti_key)
    sub_dimension_pp = find_or_create_by_name(sti_key, append_name(mounting_pp.name, sti_key.to_s))
    associate_unless_included(mounting_pp, sub_dimension_pp)
  end

  def find_or_create_by_name(klass, name)
    to_konstant(klass).where(name: name).first_or_create
  end

  def associate_unless_included(origin, target)
    to_kollection(origin, target) << target unless to_kollection(origin, target).include?(target)
  end

  def classified_types(type)
    self_join_assocs(type).map {|t| to_classify(t)}
  end

  def org_categories(type_key)
    h = {product_kind: ['Flat-Art', 'Sericels', 'Sculptures']}
    h[:"#{type_key}"]
  end

  def org_subcategories(type_key)
    h ={product_kind: ['Material', 'Dimension', 'Mounting']}
    h[:"#{type_key}"]
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
