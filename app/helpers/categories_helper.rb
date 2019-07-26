module CategoriesHelper
  def populate_categories
    origin_category = find_or_create_by_name('Category')
    categories =[]
    self_join_assocs('category', :category).each do |type|
      category = find_or_create_by_name(to_classify(type))
      find_or_associate(origin_category, category)
      categories << category
    end
    pk = categories.select {|i| i.name == 'ProductKind'}.first
    populate_sub_categories(pk)
    #categories
  end

  def classified_types(type)
    self_join_assocs(type).map {|t| to_classify(t)}
  end

  def populate_sub_categories(category_type)
    type_key = to_snake(category_type.name)
    category_types(type_key).each do |obj_name|
      obj_category = find_or_create_by_name(obj_name)
      find_or_associate(category_type, obj_category)
      populate_nested_categories(obj_category, type_key)
    end
  end

  def populate_nested_categories(category, type_key)
    sub_category_types(type_key).each do |sub_obj_name|
      name = category.name.split('-').first.singularize
      sub_category_name = [name, sub_obj_name].join('-').pluralize
      sub_category = find_or_create_by_name(sub_category_name)
      find_or_associate(category, sub_category)
    end
  end

  def find_or_create_by_name(name)
    Category.where(name: name).first_or_create
  end

  def find_or_associate(origin, target)
    origin.categories << target unless origin.categories.include?(target)
  end

  def category_types(type_key)
    h = {product_kind: ['Flat-Art', 'Sericels', 'Sculptures']}
    h[:"#{type_key}"]
  end

  def sub_category_types(type_key)
    h ={product_kind: ['Material', 'Dimension', 'Mounting']}
    h[:"#{type_key}"]
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
