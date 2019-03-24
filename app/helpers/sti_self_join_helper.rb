module StiSelfJoinHelper
  def self_join_assocs(obj, *parent_obj)
    child_subklasses= []
    to_konstant(obj).reflect_on_all_associations(:has_many).map{|a| to_snake(a.name)}.each do |a|
      child_subklasses << a if shared_superklass(a, obj) && not_parent?(a, parent_obj)
    end
    child_subklasses.flatten
  end

  def shared_superklass(obj1, obj2)
    to_super_klass_name(obj1) == to_super_klass_name(obj2)
  end

  def not_parent?(obj1, obj2)
    obj1 != to_snake(obj2[0])
  end
end
