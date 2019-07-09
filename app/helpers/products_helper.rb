module ProductsHelper
  def product_media_types
    ['product_kind', 'medium', 'material']
  end

  def product_sub_part_types
    ['edition', 'signature', 'certificate']
  end

  def build_identifier_params(selection, opt={})
    selection.map {|prxy| opt[to_fks(prxy.name)] = prxy.pluck(:id)}
    opt
  end

  #1a
  def product_select(product, f)
    if type = product_media_types.detect {|type| !has_kollection?(product, type)}
      set_product_params(product, type, f)
    end
  end

  #1b
  def set_product_params(product, type, f)
    if type == 'product_kind'
      kollection = ProductKind.all
    else
      pk = product.product_kinds.first
      h = product_media_group(pk)
      kollection = h[type]
    end
    concat(render(partial: "product_item_groups/products/select", locals: {product: product, type: type, kollection: kollection, f: f}))
  end

  def product_media_group(pk)
    h = {parent: pk}
    ['product_kind', 'medium', 'material'].each do |type|
      product_kind_group(pk, h, type)
    end
    h
  end

  def product_kind_group(pk, h, type)
    if type == 'product_kind'
      h[type] = set_product_kind(pk, type)
      #h["#{type}_field"] = set_product_kind_field(h, type)
    else
      h[type] = set_sub_part(h['product_kind'], type)
    end
  end

  def set_product_kind(pk, type)
    #if pk2 = has_kollection?(pk, type)
    if pk2 = has_obj?(pk, type)
      pk2
    else
      pk
    end
  end

  def set_sub_part(pk, type)
    if sub_obj = has_kollection?(pk, type)
      if sub_obj.count == 1
        has_kollection?(sub_obj.first, type)
      else
        sub_obj
      end
    end
  end

  def set_field(obj, type)
    field = "#{type}_field"
    if fields = has_kollection?(obj, field)
      fields
    end
  end

  def set_product_kind_field(h, type)
    if h[:parent] == h['product_kind']
      set_field(h['product_kind'], type)
    else
      [h[:parent], h['product_kind']].map {|obj| set_field(obj, type)}
    end
  end

  def sub_part_group_set(p)
    obj_set = product_sub_part_group(p)
    opt_idx = [[0,1,2], [0,1], [0,2], [0]]
    opts = []
    opt_idx.each do |opt_set|
      opt_values = opt_set.map {|i| obj_set[i]}.compact
      opt_name = arr_to_text(opt_values.map {|proxy| abbrv_type(proxy.name)})
      opts << opt_values.unshift(opt_name)
    end
    opts
  end

  def product_sub_part_group(p)
    if pk = has_obj?(p, 'product_kind')
      pk_set = product_kind_set(pk)
      objs = pk_set.map {|pk| product_sub_part_types.map {|type| get_nested_parts_or_fields(pk, type)}.reject {|i| i.nil?}}.flatten(1)
    end
  end

  def product_kind_set(pk)
    if pk2 = has_obj?(pk, 'product_kind')
      [pk, pk2]
    else
      [pk]
    end
  end

  def get_nested_parts_or_fields(pk, type)
    if obj_kollection = has_kollection?(pk, type)
      obj = obj_kollection.first
      if has_shared_type_kollection?(obj)
        obj_kollection
      #elsif field_kollection = has_kollection?(obj, obj.class.name + '_field')
      elsif field_kollection = has_field_kollection?(obj)
        field_kollection
      end
    end
  end

  def has_shared_type_kollection?(obj)
    if shared_type_kollection = has_kollection?(obj, obj.class.name)
      shared_type_kollection
    end
  end

  def has_field_kollection?(obj)
    if field_kollection = has_kollection?(obj, obj.class.name + '_field')
      field_kollection
    end
  end

  def selected_id?(obj, assoc_name)
    if obj = has_obj?(obj, assoc_name)
      obj.id
    else
      nil
    end
  end

  def product_name(product)
    product_media_types.map {|type| format_product_name(product, type)}.reject {|i| i.nil?}.join(" ")
  end

  def format_product_name(product, type)
    if sub_part = has_obj?(product, type)
      if type == 'product_kind'
        sub_part.name.split(" ").reject {|word| ['prints','art', 'print-media'].include?(word)}.join(" ")
      elsif type == 'medium'
        sub_part.name
      elsif type == 'material'
        "on #{sub_part.name}"
      end
    end
  end
end
