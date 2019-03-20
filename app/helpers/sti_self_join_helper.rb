module StiSelfJoinHelper
  def self_join_assocs(parent_obj)
    child_subklasses= []
    to_konstant(parent_obj).reflect_on_all_associations(:has_many).map{|a| to_snake(a.name)}.each do |a|
      child_subklasses << a if shared_superklass(a, parent_obj)
    end
    child_subklasses
  end

  def to_super_klass_name(obj)
    if obj.class == String
      obj.classify.constantize.superclass.name
    elsif obj.class == Symbol
      obj.to_s.classify.constantize.superclass.name
    else
      obj.class.superclass.name
    end
  end

  #=> product_part, item_field, item_value
  def shared_superklass(obj1, obj2)
    to_super_klass_name(obj1) == to_super_klass_name(obj2)
  end
end
