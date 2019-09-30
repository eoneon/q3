module CastType
  ###################################################
  #return_type = __method__.to_s.split('_').last
  ###################################################

  def self.to_other_type(obj, type, return_type)
    if [String, Symbol].include?(type)
      public_send('str_to_' + return_type, obj.str)
    else
      public_send('ar_to_' + return_type, type)
    end
  end

  ###################################################

  def self.to_snake(obj)
    to_other_type(obj, obj.class, 'snake')
  end

  def self.to_konstant(obj)
    to_other_type(obj, obj.class, 'konstant')
  end

  def self.to_classify(obj)
    to_other_type(obj, obj.class, 'classify')
  end

  def self.to_superklass(obj)
    to_other_type(obj, obj.class, 'superklass')
  end

  ################################################### ConvertTo

  #convert string to: snake_case, constant, class, superclass
  def self.str_to_snake(str)
    str.underscore.singularize
  end

  def self.str_to_konstant(str)
    str.classify.constantize
  end

  def self.str_to_classify(str)
    str.classify
  end

  def self.str_to_superklass(str)
    str.classify.constantize.superclass.name
  end

  #convert ar-obj to: snake_case, constant, class, superclass
  def self.ar_obj_to_snake(ar_obj)
    ar_obj.class.name.underscore
  end

  def self.ar_obj_to_konstant(ar_obj)
    ar_obj.class.name.constantize
  end

  def self.ar_obj_to_classify(ar_obj)
    ar_obj.class.name.classify
  end

  def self.ar_obj_to_superklass(ar_obj)
    ar_obj.class.superclass.name
  end

  def dog_non_self_test
    'love'
  end

  # def self.dog_self_test
  #   'self love'
  # end
end
