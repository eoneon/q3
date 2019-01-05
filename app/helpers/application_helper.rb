module ApplicationHelper
  def dom_ref(*obj_ref)
    obj_ref.compact.map {|i| format_ref(i)}.join('-')
  end

  def format_ref(i)
    i.class == String ? i : klass_and_id(i)
  end

  def new_dom_ref(str, pat, pat2)
    repl_at(str.split('-'), pat, pat2)
  end

  def repl_at(str_arr, pat, pat2)
    idx = str_arr.index(pat)
    [str_arr.take(idx), pat2].compact.join('-')
  end

  def dom_attr(str, optns, *tags)
    if include_any?(str.split('-'), tags)
      handle_option_by_type(optns, 0)
    else
      handle_option_by_type(optns, 1)
    end
  end

  def dom_exclude(str, optn, tag)
    optn if str.split('-').exclude?(tag)
  end

  def dom_cond(str, *tags)
    include_any?(str.split('-'), tags)
  end

  def handle_option_by_type(optns, n)
    if optns.class == Array
      optns[n]
    else
      optns if n == 0
    end
  end

  def include_any?(arr_x, arr_y)
    arr_x.any? {|x| arr_y.include?(x)}
  end

  def include_pat?(str, pat)
    str.index(/#{pat}/)
  end



  ####end
  def dyno_id(args={})
    arr = [:n1, :k1, :n2, :k2, :tag].keep_if {|k| args.has_key?(k)}
    arr.map {|k| format_id_args(args, k)}.join('-')
  end

  def format_id_args(args, k)
    [:k1, :k2].include?(k) ? klass_id(args[k]) : args[k]
  end

  def klass_id(klass)
    klass.id if klass.present?
  end

  def klass_name(klass)
    #klass.class == String ? klass.downcase.singularize : klass.class.name.underscore
    klass.class.name.underscore if klass.present?
  end

  def klass_and_id(klass)
    [klass_name(klass), klass.id].join('-')
  end

  def klass_with_id(klass)
    join_params([klass_name(klass), klass.id]) if klass.present?
  end

  def join_params(args)
    args.join("-")
  end

  def konstant(klass)
    klass.class == String ? klass.camelize.constantize : klass.class.name.constantize
  end
  ###

  # def klass_name(klass)
  #   klass.class == String ? klass.downcase.singularize : klass.class.name.underscore
  # end

  def kollection_name(klass)
    klass.class == String ? klass.downcase.pluralize : klass.class.name.underscore.pluralize
  end

  # def klass_with_id(klass)
  #   join_params([klass_name(klass), klass.id])
  # end

  # def join_params(args)
  #   args.join("-")
  # end

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
