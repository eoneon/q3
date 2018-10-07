module ApplicationHelper
  def selected_option(obj_ids, collection)
    if intersection = obj_ids & collection.pluck(:id)
      option_id = intersection[0]
    end
    option_id if option_id.present?
  end

  # def local_obj(obj)
  #   obj.present? ? obj : Category.first
  # end
  def klass_to_str(obj)
    obj.class.name.underscore
  end

  def klass_to_str_plural(obj)
    klass_to_str(obj).pluralize
  end

  def poly_path_categorizable_name(obj)
    [klass_to_str_plural(obj), klass_to_str(obj), klass_to_str(obj) + "_name"].join("/")
  end

  def form_id(obj_arr)
    obj_arr.map {|obj| klass_to_str(obj)}.join("_") + "_form"
  end

  ####NEW HELPERS
  def klass_name(klass)
    klass.class == String ? klass : klass.class.name.underscore
  end

  def kollection_name(klass)
    klass.class == String ? klass : klass.class.name.underscore.pluralize
  end

  def klass_with_id(klass)
    join_params([klass_name(klass), klass.id])
  end

  def join_params(args)
    args.join("-")
  end

  def join_nested_klass(name, target, child_klass)
    if name == "target-collection"
      join_params([target, kollection_name(child_klass)])
    else
      join_params([target, klass_name(child_klass)])
    end
  end

  def target(name, klass)
    if klass.class == String
      target = join_params([name, klass_name(klass)])
    else
      target = join_params([name, klass_with_id(klass)])
    end
  end

  def dynamic_id(name:, klass:, child_klass:)
    target = target(name, klass)
    if child_klass.present?
      join_nested_klass(name, target, child_klass)
    else
      target
    end
  end
end
