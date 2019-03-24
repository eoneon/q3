module DomRefHelper
  def dom_ref(*obj_ref)
    obj_ref.compact.map {|i| format_ref(i)}.join('-')
  end

  def format_ref(i)
    i.class == String || i.class == Fixnum ? i : klass_with_id(i)
  end

  def klass_with_id(klass)
    [to_snake(klass), klass.id].join('-') if klass.present?
  end

  def new_dom_ref(str, pat, pat2)
    repl_at(str.split('-'), pat, pat2)
  end

  def repl_at(str_arr, pat, pat2)
    idx = str_arr.index(pat)
    [str_arr.take(idx), pat2].compact.join('-')
  end
end
