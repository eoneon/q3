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
end
