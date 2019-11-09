module BuildSet

  def find_or_create_by(kind:, name:)
    if name.is_a? Array
      find_or_create_by_names(kind: kind, names: name)
    else
      return Element.where(kind: kind, name: name).first_or_create
    end
  end

  def find_or_create_by_names(kind:, names:)
    objs = []
    names.each do |name|
      objs << Element.where({kind: kind, name: name}).first_or_create
    end
    return objs
  end

  def find_or_create_by_and_assoc(origin:, kind:, name: )
    if name.is_a? Array
      find_or_create_by_names_and_assoc(origin: origin, kind: kind, names: name)
    else
      target = Element.where(kind: kind, name: name).first_or_create
      assoc_unless_included(origin: origin, target: target)
      return target
    end
  end

  def find_or_create_by_names_and_assoc(origin:, kind:, names:)
    targets =[]
    names.each do |target_name|
      target = Element.where({kind: kind, name: name}).first_or_create
      targets << target
      assoc_unless_included(origin: origin, target: target)
    end
    return targets
  end

  ###################################################

  def assoc_unless_included(origin:, target:)
    origin.elements << target if origin.element_ids.exclude?(target.id)
  end

  def assoc_set_unless_included(origin:, kind:, targets:)
    origin.elements << targets unless origin.elements.where(kind: kind).pluck(:id).sort == targets.map(&:id).sort
  end

  def assoc_scoped_collection(origin:, target:)
    to_collection(origin: origin, assoc_obj: target) << target
  end

  def to_collection(origin:, assoc_obj:)
    origin.public_send(collection_name(assoc_obj))
  end

  def collection_name(assoc_obj)
    to_snake(assoc_obj).pluralize
  end

  # ###################################################
  # #return_type = __method__.to_s.split('_').last
  # ###################################################

  ###################################################

  def to_other_type(obj, type, return_type)
    if [String, Symbol].include?(type)
      public_send('str_to_' + return_type, obj.to_s)
    else
      public_send('ar_obj_to_' + return_type, type)
    end
  end

  ###################################################

  def to_snake(obj)
    to_other_type(obj, obj.class, 'snake')
  end

  def to_constant(obj)
    to_other_type(obj, obj.class, 'constant')
  end

  def to_classify(obj)
    to_other_type(obj, obj.class, 'classify')
  end

  def to_superklass(obj)
    to_other_type(obj, obj.class, 'superklass')
  end

  ################################################### ConvertTo

  #convert string to: snake_case, constant, class, superclass
  def str_to_snake(str)
    str.underscore.singularize
  end

  def str_to_constant(str)
    str.classify.constantize
  end

  def scoped_constant(*konstant)
    #to_constant([self.name, konstant].join('::'))
    to_constant(konstant.prepend(self.name).join('::'))
  end

  def to_scoped_constant(*konstants)
    konstants.map{|konstant| konstant.to_s.classify}.join('::').constantize
  end

  def str_to_classify(str)
    str.classify
  end

  def str_to_superklass(str)
    str.classify.constantize.superclass.name
  end

  # def scoped_konstant(*konstant)
  #   konstant = konstant.map {|k| to_classify(k)}.join('::')
  #   to_constant(konstant.map {|k| to_classify(k)}.join('::'))
  # end
  #convert ar-obj to: snake_case, constant, class, superclass
  def ar_obj_to_snake(ar_obj)
    ar_obj.class.name.underscore
  end

  def ar_obj_to_constant(ar_obj)
    ar_obj.class.name.constantize
  end

  def ar_obj_to_classify(ar_obj)
    ar_obj.class.name.classify
  end

  def ar_obj_to_superklass(ar_obj)
    ar_obj.class.superclass.name
  end

  ################################################### array methods

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

  def obj_set(nested_arr)
    nested_arr.map {|set| set.last}.flatten
  end

  def name_set(nested_arr)
    obj_set(nested_arr).map {|obj| obj.name}
  end

  ################################################### word format methods

  def arr_to_text(arr)
    if arr.length == 2
      arr.join(" & ")
    elsif arr.length > 2
      [arr[0..-3].join(", "), arr[-2, 2].join(" & ")].join(", ")
    else
      arr[0]
    end
  end

  def format_vowel(vowel, word)
    if %w[a e i o u].include?(word.first.downcase) && word.split('-').first != 'one'
      'an'
    else
      'a'
    end
  end

  def hyph_word(word)
    word.split(' ').join('-')
  end

  def word_arr(arr)
    arr.split(' ').join(' ').split(' ')
  end

  ###################################################

  def update_tags(obj, tag_hsh)
    obj.tags = tag_hsh
    obj.save
  end

  def set_tags(name_set, tags={})
    name_set.map {|name| tags.merge!(h={name.split(' ').join(' ') => 'true'})}
    tags
  end

end
