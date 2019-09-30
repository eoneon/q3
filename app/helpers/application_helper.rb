module ApplicationHelper
  # def my_test
  #   __method__ #.to_s.split('_').last
  # end
  #convert string, symbol, obj to formatted str representation of klass
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
    fk = to_snake(obj) + '_id'
    fk.to_sym
  end

  def to_fks(obj)
    fks = to_snake(obj) + '_ids'
    fks.to_sym
  end

  def to_classify(obj)
    if obj.class == String
      obj.classify
    elsif obj.class == Symbol
      obj.to_s.classify
    else
      obj.class.name.classify
    end
  end

  def to_kollection_name(obj)
    to_snake(obj).pluralize
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

  #convert string, symbol, obj to constant or AR collection
  def to_konstant(obj)
    if obj.class == String
      obj.classify.constantize
    elsif obj.class == Symbol
      obj.to_s.classify.constantize
    else
      obj.class.name.constantize
    end
  end

  def to_kollection(parent_obj, child_obj)
    parent_obj.public_send(to_kollection_name(child_obj))
  end

  def relation_any?(parent_obj, child_obj)
    to_kollection(parent_obj, child_obj).first if parent_obj.public_send(to_snake(child_obj))
  end

  #array and string parsing and comparison methods
  def include_any?(arr_x, arr_y)
    arr_x.any? {|x| arr_y.include?(x)}
  end

  def include_all?(arr_x, arr_y)
    arr_x.all? {|x| arr_y.include?(x)}
  end

  def exclude_all?(arr_x, arr_y)
    arr_x.all? {|x| arr_y.exclude?(x)}
  end

  def include_none?(arr_x, arr_y)
    arr_x.all? {|x| arr_y.exclude?(x)}
  end

  def include_pat?(str, pat)
    str.index(/#{pat}/)
  end

  def dom_opt(ref, opts={}, *alt_v)
    if v = opts.detect {|k,v| v if ref.split('-').include?(k.to_s)}
      v[-1]
    elsif alt_v.any?
      alt_v[0]
    end
  end

  #replaces: obj_to_hyph_str(obj) upper_single(klass) upper_single(klass) and adds add'l combos + alias for to_snake
  def to_txt(obj, opts={})
    txt = to_snake(obj)
    txt.capitalize! if opts.has_key?(:cap)
    txt = txt.pluralize if opts.has_key?(:plur)
    j = opts.has_key?(:j) ? opts[:j] : ''
    txt = txt.split('_').join(j)
    opts.has_key?(:up) ? txt.upcase : txt
  end

  def append_name(sti, suffix)
    [sti, suffix].join('-')
  end

  def obj_ref(dom_ref)
    dom_arr = dom_ref.split("-")
    idx = dom_arr.rindex{|i| is_number?(i)}
    idx = idx.nil? ? dom_arr.rindex("new") : idx
    dom_arr[0..idx].join("-")
  end

  def is_number?(obj)
    obj.to_s == obj.to_i.to_s || obj.to_s == obj.to_f.to_s
  end

  def cond_attr(eval_test, rslt, *attrs)
    if eval_test == rslt
      attrs[0]
    elsif attrs.count == 2
      attrs[-1]
    end
  end

  #array and string parsing methods for rendering conditional dom elements
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

  def handle_option_by_type(optns, n)
    if optns.class == Array
      optns[n]
    else
      optns if n == 0
    end
  end

  #replaces: dom_cond
  def ref_include?(str, *tags)
    include_any?(str.split('-'), tags)
  end

  #replaces: dom_exclude
  def ref_exclude?(str, optn, tag)
    optn if str.split('-').exclude?(tag)
  end

  def dom_cond(str, *tags)
    include_any?(str.split('-'), tags)
  end

  def check_cond(str, cond, *tags)
    public_send('include_' + cond + '?', str.split('-'), tags)
  end

  #string formatting methods for views: presentation
  def arr_to_text(arr)
    if arr.length == 2
      arr.join(" & ")
    elsif arr.length > 2
      [arr[0..-3].join(", "), arr[-2, 2].join(" & ")].join(", ")
    else
      arr[0]
    end
  end

  def obj_to_hyph_str(obj)
    to_snake(obj).split('_').join('-')
  end
  #kill
  def obj_to_cap_hyph_str(obj)
    to_snake(obj).split('_').map {|i| i.capitalize}.join('-')
  end
  #kill
  def upper_single(klass)
    klass_name = to_snake(klass)
    klass_name.pluralize.split('_').join(' ').upcase
  end

  def card_title(origin, target)
    "#{origin.name} #{obj_to_hyph_str(target).pluralize}"
  end

  #used only inside dynamic form used by both: product_part/item_field?
  def name_param(target)
    if to_snake(target).split('_')[-1] == 'field'
      :field_name
    else
      :name
    end
  end

  def uniq_vl(parent_obj, kollection_name, text_method)
    set = parent_obj.public_send(to_kollection_name(kollection_name)).pluck(:"#{text_method}").uniq #+ [parent_obj.name]
    set = set + [parent_obj.name] if to_super_klass_name(parent_obj) == "ProductPart"
    to_konstant(kollection_name).where.not("#{text_method}": set)
  end

  # def readable_obj_set(obj_set)
  #   a = []
  #   obj_set.each do |set|
  #     if set.first.class == Array
  #       a << set.map {|obj| make_obj_set_readable(obj)}
  #     else
  #       a << make_obj_set_readable(obj)
  #     end
  #   end
  #   a
  # end
  def readable_obj_set(set)
    set.map {|subset| subset.map {|obj| make_obj_set_readable(obj)}}
  end

  def make_obj_set_readable(obj)
    "#{obj.type}: #{obj.id}, #{obj.name}"
  end

  def filtered_thru_vl(parent_obj, child_obj, other_obj)
    id_set = parent_obj.public_send(to_kollection_name(child_obj)).map{|obj| obj.public_send(to_kollection_name(other_obj)).first}
    to_konstant(other_obj).where.not(id: id_set)
  end
end
