module StiSelfJoinHelper
  def self_join_assocs(obj, *exclude_objs)
    child_subklasses= []
    to_konstant(obj).reflect_on_all_associations(:has_many).map{|assoc| to_snake(assoc.name)}.each do |assoc|
      child_subklasses << assoc if shared_superklass(assoc, obj) && not_on_reject_list?(assoc, exclude_objs)
    end
    child_subklasses.flatten
  end

  def obj_assocs(obj)
    to_konstant(obj).reflect_on_all_associations(:has_many).map{|assoc| to_snake(assoc.name)}
  end

  def shared_superklass(obj1, obj2)
    to_super_klass_name(obj1) == to_super_klass_name(obj2)
  end

  def not_on_reject_list?(obj, reject_list)
    reject_list.map{|obj| to_snake(obj)}.exclude?(obj)
  end
end
