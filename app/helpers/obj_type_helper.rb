module ObjTypeHelper
  def to_konstant(obj)
    if obj.class == String
      obj.classify.constantize
    elsif obj.class == Symbol
      obj.to_s.classify.constantize
    else
      obj.class.name.constantize
    end
  end

  def to_kollection_name(obj)
    to_snake(obj).pluralize
  end

  def to_snake(obj)
    if obj.class == String
      obj.underscore.singularize
    elsif obj.class == Symbol
      obj.to_s.underscore.singularize
    else
      obj.class.name.underscore
    end
  end

  def to_fk(obj)
    to_snake(obj) + '_id'
  end
end
