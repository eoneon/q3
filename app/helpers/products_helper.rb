module ProductsHelper
  def media_types
    ['product_kind', 'medium', 'material']
  end

  def identifier_types
    ['edition', 'signature', 'certificate']
  end
  #use pop! to slice off first item and change arr
  def identifier_opts_idx(obj_set)
    if obj_set.map {|i| i.name}.include?("Edition")
      [[0,1,2], [0,1], [0,2], [0]]
    else
      [[0,1], [0], [1]]
    end
  end

  def opts_set(all_identifiers)
    idx_set = identifier_opts_idx(all_identifiers) #=> [[0,1,2], [0,1], [0,2], [0]]
    #idx_complete_subset = idx_set.slice(0) #=> [0,1,2]
    proxy_names = all_identifiers.map {|prxy| prxy.name} #=> ["Edition","SignatureField","CertificateField"]
    param_set = identifier_params(all_identifiers) #=> {:edition_ids=>[17], :signature_field_ids=>[4], :certificate_field_ids=>[10]}

    params = [[proxy_names, param_set]]

    idx_set.drop(1).each do |idx_subset| #idx_set.drop(1) => [[0,1], [0,2], [0]]
      #inverse_set = idx_complete_subset - idx_subset
      #=> [0,1,2] - [0,1] => [2]
      #empty_keys = inverse_set.map {|idx| to_fks(proxy_names[idx])} #=> "CertificateField" => [:certificate_field_ids]
      types = idx_subset.map {|idx| proxy_names[idx]} #=> ["Edition","SignatureField"]
      # empty_keys = proxy_names - names
      # empty_keys = empty_keys.map {|name| to_fks(name)}
      empty_keys = empty_keys(proxy_names, types)
      #h = fk_opt_hash(param_set, empty_keys, h={})
      #h = {}
      #h = param_set.each { |k,v| empty_keys.include?(k) ? h[k] = [] : h[k] = v}
      params << [types, fk_opt_hash(param_set, empty_keys, h={})]
    end
    params
  end

  def fk_opt_hash(param_set, empty_keys, h={})
    param_set.each { |k,v| empty_keys.include?(k) ? h[k] = [] : h[k] = v}
    h
  end

  def empty_keys(proxy_names, types)
    empty_keys = proxy_names - types
    empty_keys.map {|type| to_fks(type)}
  end

  def opt_types(product)
    identifier_set(product).map {|i| i.name}
  end

  def selected_opt(product)
    product.item_groups.where(target_type: opt_types(product)).pluck(:target_type)
  end
  # def identifier_elements(p)
  #   unless media_types.detect {|type| !has_kollection?(p, type)}
  #     identifier_opts(p)
  #   end
  # end

  def identifier_params(selection, opt={})
    selection.map {|prxy| opt[to_fks(prxy.name)] = prxy.pluck(:id)}
    opt
  end

  #1a
  def product_select(p, f)
    if type = media_types.detect {|type| !has_kollection?(p, type)}
      set_product_params(p, type, f)
    # end
    else
      objs = identifier_opts(p)
      concat(render(partial: "product_item_groups/products/identifiers", locals: {objs: objs}))
      #concat(render(partial: "product_item_groups/products/identifiers_check_box", locals: {p: p, objs: objs}))
      identifier_check_boxes(p, objs)
    end
  end

  def identifier_check_boxes(p, objs)
    #if opt_objs = identifier_opts(p)[0][-1]
      objs[0][-1].each_pair do |opt_obj, ids|
        concat(render(partial: "product_item_groups/products/identifiers_check_box", locals: {p: p, opt_obj: opt_obj, ids: ids}))
      end
    #end
  end

  def has_check_box_id?(obj, fks, id)
    obj.public_send(fks).include?(id)
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
    media_types.each do |type|
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

  def identifier_opts(p)
    obj_set = identifier_set(p)
    opt_idx = identifier_opts_idx(obj_set)
    opts = []
    opt_idx.each do |opt_set|
      opt_values = opt_set.map {|i| obj_set[i]}.compact
      opt_types = opt_values.map {|proxy| proxy.name}
      opts << [opt_types.map {|type| to_fks(type)}.join(' '), identifier_params(opt_values)].unshift(arr_to_text(opt_types.map {|type| abbrv_type(type)}))
    end
    opts
  end

  def identifier_set(p)
    if pk = has_obj?(p, 'product_kind')
      pk_set = product_kind_set(pk)
      objs = pk_set.map {|pk| identifier_types.map {|type| get_nested_parts_or_fields(pk, type)}.reject {|i| i.nil?}}.flatten(1)
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
    media_types.map {|type| format_product_name(product, type)}.reject {|i| i.nil?}.join(" ")
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
