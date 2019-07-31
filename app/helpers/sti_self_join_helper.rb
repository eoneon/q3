module StiSelfJoinHelper
  def self_join_assocs(obj, *exclude_objs)
    child_subklasses= []
    to_konstant(obj).reflect_on_all_associations(:has_many).map{|assoc| to_snake(assoc.name)}.each do |assoc|
      child_subklasses << assoc if shared_superklass(assoc, obj) && not_on_reject_list?(assoc, exclude_objs)
    end
    child_subklasses.flatten
  end

  #############

  #STI associations
  def sti_kollection(obj, *exclude_objs)
    has_many_sti_assocs(obj).map {|assoc_name| has_kollection?(obj, assoc_name) if not_on_reject_list?(assoc_name, exclude_objs)}.reject {|i| i.empty?}
  end

  #############

  def has_obj?(obj, type)
    to_kollection(obj, type).first if to_kollection(obj, type).any?
  end

  def has_kollection?(obj, type)
    to_kollection(obj, type) if to_kollection(obj, type).any?
  end

  #############
  #assoc_name to_snake
  def has_many_assoc_names(obj)
    to_konstant(obj).reflect_on_all_associations(:has_many).map{|assoc_name| to_snake(assoc_name.name)}
  end

  #STI assoc_name to_snake
  def has_many_sti_assoc_names(obj)
    has_many_assoc_names(obj).map {|assoc_name| assoc_name if shared_superklass(assoc_name, obj)}.compact
  end

  #STI assoc_name to_snake IF assocication
  def has_many_sti_assocs(obj)
    has_many_sti_assoc_names(obj).map {|assoc_name| assoc_name if to_kollection(obj, assoc_name).any?}.compact
  end


  #working: check console for working example
  def obj_assocs(obj)
    to_konstant(obj).reflect_on_all_associations(:has_many).map{|assoc| to_snake(assoc.name)}
  end

  def sti_assocs(obj)
    obj_assocs(obj).map {|assoc| assoc if shared_superklass(assoc, obj) && to_kollection(obj, assoc).any?}.compact
  end

  # def sti_kollection(obj)
  #   sti_assocs(obj, types).map {|assoc| sub_kollection(obj, assoc)}.reject {|i| i.empty?}
  # end

  def shared_superklass(obj1, obj2)
    to_super_klass_name(obj1) == to_super_klass_name(obj2)
  end

  def not_on_reject_list?(obj, reject_list)
    reject_list.map{|obj| to_snake(obj)}.exclude?(obj)
  end

  # def sub_group(obj, types)
  #   sub_obj = types.map {|i| to_kollection(obj, i) if to_kollection(obj, i).any?}.compact.flatten
  #   if sub_obj.count == 1
  #     sub_group(sub_obj.first, types)
  #   else
  #     obj
  #   end
  # end

  # def permitted?(type, *types)
  #   true if types.any? && types.include?(type)
  # end

  # def sub_kollection(obj, assoc)
  #   if assoc == 'material'
  #     sub_obj = to_kollection(obj, assoc).first
  #     sti_assocs(sub_obj).map {|assoc| to_kollection(sub_obj, assoc)}.reject {|i| i.empty?}
  #   else
  #     to_kollection(obj, assoc)
  #   end
  # end
  #
  # def nested_assocs(obj)
  #   arr = []
  #   types = ['product_kind', 'medium', 'material']
  #   sti_assocs(obj, types).each do |assoc|
  #     sub_obj = to_kollection(obj, assoc).first
  #     if sti_assocs(sub_obj, types).any?
  #       arr << sti_kollection(sub_obj, types)
  #     else
  #       arr << sub_obj
  #     end
  #   end
  #   arr.compact.flatten(1).map {|i| i.class ==  Array ? i.flatten : i}
  # end
  # def nested_sti_kollection(obj)
  #   result = []
  #   has_many_sti_kollection(obj).each do |kollection|
  #     result << nested_sub_kollection(kollection)
  #   end
  #   result
  # end
  #
  # def kollection_and_sub_kollection(obj)
  #   has_many_sti_assoc_names(obj).map {|assoc_name| nested_sub_kollection(to_kollection(obj, assoc_name)) if to_kollection(obj, assoc_name)}.reject {|i| i.empty?}
  # end

  # def nested_sub_kollection(kollection)
  #  types = ['ProductKind', 'Material']
  #  if kollection.count == 1 && types.include?(kollection[0].name)
  #     sub_obj = kollection.first
  #     kollection_and_sub_kollection(sub_obj)
  #   else
  #     kollection
  #   end
  # end

  # def product_media(pk)
  #   h = {parent: pk}
  #   ['product_kind', 'medium', 'material'].each do |type|
  #     product_selects(pk, h, type)
  #   end
  #   h
  # end
  #
  # def product_selects(pk, h, type)
  #   if type == 'product_kind'
  #     h[type] = set_product_kind(pk, type)
  #     h["#{type}_field"] = set_product_kind_field(h, type)
  #   else
  #     h[type] = set_sub_part(h['product_kind'], type)
  #   end
  # end
  #
  # def set_product_kind(pk, type)
  #   if pk2 = has_kollection?(pk, type)
  #     pk2.first
  #   else
  #     pk
  #   end
  # end
  #
  # def set_sub_part(pk, type)
  #   if sub_obj = has_kollection?(pk, type)
  #     if sub_obj.count == 1
  #       has_kollection?(sub_obj.first, type)
  #     else
  #       sub_obj
  #     end
  #   end
  # end
  #
  # def set_field(obj, type)
  #   field = "#{type}_field"
  #   if fields = has_kollection?(obj, field)
  #     fields
  #   end
  # end
  #
  # def set_product_kind_field(h, type)
  #   if h[:parent] == h['product_kind']
  #     set_field(h['product_kind'], type)
  #   else
  #     [h[:parent], h['product_kind']].map {|obj| set_field(obj, type)}
  #   end
  # end

  # def set_sub_kollection(pk, type)
  #   if sub_obj = has_kollection?(pk, type)
  #     sub_obj
  #   end
  # end
  # def product_media(pk)
  #   pk_set = set_pk(pk)
  #
  #   pk2 = set_pk(pk).last
  #
  #   media_set = []
  #   media_set << to_kollection(pk2, 'medium')
  #   material = has_obj?(pk2, 'material')
  #   media_set << to_kollection(material, 'material')
  #   h = {pk_set: pk_set, media_set: media_set}
  # end
  #
  # def set_pk(pk)
  #   if pk2 = has_obj?(pk, 'product_kind')
  #     [pk, pk2]
  #   else
  #     [pk]
  #   end
  # end
end
