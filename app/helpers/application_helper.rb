module ApplicationHelper
  def dyno_id(args={})
    arr = [:n1, :k1, :n2, :k2, :tag].keep_if {|k| args.has_key?(k)}
    arr.map {|k| format_id_args(args, k)}.join('-')
  end

  def format_id_args(args, k)
    [:k1, :k2].include?(k) ? klass_id(args[k]) : args[k]
  end

  def collapse_show?(selector, *tags)
    'show' if include_any?(selector.split('-'), tags)
  end

  def include_any?(arr_x, arr_y)
    arr_x.any? {|x| arr_y.include?(x)}
  end

  def klass_id(klass)
    klass.id if klass.present?
  end

  ###
  def konstant(klass)
    klass.class == String ? klass.camelize.constantize : klass.class.name.constantize
  end

  def klass_name(klass)
    klass.class == String ? klass.downcase.singularize : klass.class.name.underscore
  end

  def kollection_name(klass)
    klass.class == String ? klass.downcase.pluralize : klass.class.name.underscore.pluralize
  end

  def klass_with_id(klass)
    join_params([klass_name(klass), klass.id])
  end

  def join_params(args)
    args.join("-")
  end

  def join_nested_klass(name, target, child_klass)
    if name.split("-").include?("collection")
      join_params([target, kollection_name(child_klass)])
    else
      target(target, child_klass)
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
