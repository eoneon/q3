module ProductsHelper
  def product_types
    ['product_kind', 'medium', 'material']
  end

  #1a
  def product_select(product, f)
    if type = product_types.detect {|type| !has_kollection?(product, type)}
      #type_params = {fk: type}
      #set_product_params(product, type_params[:fk])
      set_product_params(product, type, f)
    end
  end

  #1b
  def set_product_params(product, type, f)
    if type == 'product_kind'
      #type_params[:kollection] = ProductKind.all
      kollection = ProductKind.all
    else
      pk = product.product_kinds.first
      h = product_group(pk)
      #type_params[:kollection] = h[type_params[:fk]]
      kollection = h[type]
    end
    concat(render(partial: "product_item_groups/products/select", locals: {product: product, type: type, kollection: kollection, f: f}))
  end

  # def test_method(product)
  #   if type = ['product_kind', 'medium', 'material'].detect {|type| !has_kollection?(product, type)}
  #     type
  #   end
  # end


  def product_form_group(product, f)
    if pk = product.product_kinds.first
      h = product_group(pk)
      ['medium', 'material'].each do |type|
        concat(render(partial: "product_item_groups/products/select", locals: {product: product, type: type, h: h, f: f}))
      end
    end
  end

  def product_group(pk)
    h = {parent: pk}
    ['product_kind', 'medium', 'material'].each do |type|
      product_kind_group(pk, h, type)
    end
    h
  end

  def product_kind_group(pk, h, type)
    if type == 'product_kind'
      h[type] = set_product_kind(pk, type)
      h["#{type}_field"] = set_product_kind_field(h, type)
    else
      h[type] = set_sub_part(h['product_kind'], type)
    end
  end

  def set_product_kind(pk, type)
    if pk2 = has_kollection?(pk, type)
      pk2.first
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

  def selected_id?(obj, assoc_name)
    if obj = has_obj?(obj, assoc_name)
      obj.id
    else
      nil
    end
  end
  # def nested_selects(product, f, *product_parts)
  #   product_parts.each do |product_part|
  #     if part = relation_any?(parent_obj, product_part)
  #       render(partial: "products/forms/select", locals: {f: ff, product_part: part})
  #       if fields = fields_any?(part)
  #         render(partial: "item_fields/fields/#{field.field_type}", locals: {f: ff, field: field})
  #       end
  #     end
  #   end
  # end
  #
  # def build_clause(product, *product_parts)
  #   clause =[]
  #   product_parts.each do |product_part|
  #     if part = relation_any?(parent_obj, product_part)
  #       if fields = fields_any?(part)
  #         clause << fields.map {|field| field.name}
  #       else
  #         clause << part.name
  #       end
  #     end
  #   end
  #   clause.flatten.join(' ').compact.join(' ')
  # end


  #here
  # def nested_product_parts(obj)
  #   self_join_assocs(obj).map{|sti| to_kollection(obj, sti)}
  # end
  #
  # def product_selections(obj)
  #   a = []
  #   product_parts = nested_product_parts(obj)
  #   product_parts.each do |sub_part|
  #     if nested_sub_parts = nested_sub_parts?(obj)
  #       a << nested_sub_parts if ['ProductKind', 'Medium', 'Material'].include?(nested_sub_parts.name)
  #     else
  #       a << sub_part
  #     end
  #   end
  #   a
  # end



  # def sub_part_select(obj, f)
  #   if nested_sub_parts = nested_sub_parts?(obj)
  #     nested_sub_parts.each do |sub_part|
  #       render(partial: "products/forms/select", locals: {f: f, sub_part: sub_part})
  #     end
  #   end
  # end
end
