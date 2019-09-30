module BuildAppData
  def self.included(base)
    #base.send :extend, CastType
    base.extend(CastType)
  end

  def find_or_create_by_name(klass:, name:)
    to_konstant(klass).where(name: name).first_or_create
  end

  def find_or_create_by_names(klass:, names:)
    objs = []
    names.each do |name|
      objs << find_or_create_by_name(klass: klass, name: name)
     end
    return objs
  end

  def find_or_create_by_name_and_assoc(origin:, assoc:, name:)
    target = find_or_create_by_name(klass: assoc, name: name)
    assoc_unless_included(origin: origin, target: target)
    return target
  end

  def find_or_create_by_names_and_assoc(origin:, assoc:, names:)
    targets =[]
    names.each do |target_name|
      target = find_or_create_by_name(klass: assoc, name: target_name)
      targets << target
      assoc_unless_included(origin: origin, target: target)
    end
    return targets
  end

  def assoc_unless_included(origin:, target:)
    to_collection(origin: origin, assoc_obj: target) << target unless to_collection(origin: origin, assoc_obj: target).include?(target)
  end

  def assoc_origins_and_target_set(origins:, target_set:)
    origins.each do |origin|
      assoc_target_set(origin: origin, target_set: target_set)
    end
  end

  def assoc_target_set(origin:, target_set:)
    target_set.map {|target| assoc_scoped_collection(origin: origin, target: target)}
  end

  ###################################################

  def assoc_scoped_collection(origin:, target:)
    to_collection(origin: origin, assoc_obj: target) << target
  end

  def to_collection(origin:, assoc_obj:)
    origin.public_send(collection_name(assoc_obj))
  end

  def collection_name(origin:, assoc_obj:)
    to_snake(obj).pluralize
  end

  # ###################################################
  # #return_type = __method__.to_s.split('_').last
  # ###################################################
  #
  def to_other_type(obj, type, return_type)
    if [String, Symbol].include?(type)
      public_send('str_to_' + return_type, obj.str)
    else
      public_send('ar_to_' + return_type, type)
    end
  end

  ###################################################

  def to_snake(obj)
    to_other_type(obj, obj.class, 'snake')
  end

  def to_konstant(obj)
    to_other_type(obj, obj.class, 'konstant')
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

  def str_to_konstant(str)
    str.classify.constantize
  end

  def str_to_classify(str)
    str.classify
  end

  def str_to_superklass(str)
    str.classify.constantize.superclass.name
  end

  #convert ar-obj to: snake_case, constant, class, superclass
  def ar_obj_to_snake(ar_obj)
    ar_obj.class.name.underscore
  end

  def ar_obj_to_konstant(ar_obj)
    ar_obj.class.name.constantize
  end

  def ar_obj_to_classify(ar_obj)
    ar_obj.class.name.classify
  end

  def ar_obj_to_superklass(ar_obj)
    ar_obj.class.superclass.name
  end

  def rat_non_self_test
    'gross'
  end
  #
  # def self.rat_self_test
  #   'self gross'
  # end
  #
  def test_self_dog
    dog_non_self_test
  end
  #
  # def test_dog
  #   dog_non_self_test
  # end
  #
  # def test_self_self_dog_with_out_self
  #   self.dog_non_self_test
  # end
  #
  # def test_self_self_dog_with_self
  #   self.dog_non_self_test
  # end
end
