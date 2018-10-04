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
end
