require 'active_support/concern'

module ObjBuild
  extend ActiveSupport::Concern

  class_methods do

    def find_or_create_by(kind:, name:)
      if name.is_a? Array
        find_or_create_by_names(kind: kind, names: name)
      else
        return self.where(kind: kind, name: name).first_or_create
      end
    end

    def find_or_create_by_names(kind:, names:)
      objs = []
      names.each do |name|
        objs << self.where({kind: kind, name: name}).first_or_create
      end
      return objs
    end

    def find_or_create_by_and_assoc(origin:, kind:, name: )
      if name.is_a? Array
        find_or_create_by_names_and_assoc(origin: origin, kind: kind, names: name)
      else
        target = self.where(kind: kind, name: name).first_or_create
        assoc_unless_included(origin: origin, target: target)
        return target
      end
    end

    def find_or_create_by_names_and_assoc(origin:, kind:, names:)
      targets =[]
      names.each do |target_name|
        target = self.where({kind: kind, name: name}).first_or_create
        targets << target
        assoc_unless_included(origin: origin, target: target)
      end
      return targets
    end

    ###################################################

    def assoc_unless_included(origin:, target:)
      origin.elements << target if origin.element_ids.exclude?(target.id)
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
    #
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

    ################################################### Casting methods

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

    ################################################### hash methods

    def update_tags(element, tag_hsh)
      k, v = tag_hsh.keys.first, tag_hsh.values.first
      if kv_missing?(element.tags) || kv_inequality?(element.tags, k, v)
        kv_missing?(element.tags) ? element.tags = tag_hsh : element.tags.merge!(tag_hsh)
         element.save
      end
      element
    end

    def kv_missing?(tags)
      tags.nil? || tags.empty?
    end

    def kv_inequality?(tags, k, v)
      !tags.has_key?(k) || tags.has_key?(k) && tags[k] != v
    end

    def missing_k?(tags, k)
      !tags.has_key?(k)
    end

    def k_not_eql_v?(tags, k, v)
      tags.has_key?(k) && tags[k] != v
    end

    ################################################### hash methods 2

    def update_product_tags(product, tag_hsh)
      # if kv_missing?(product.tags)
      #   product.tags = tag_hsh
      # else
      #   tag_hsh.keys.each do |k|
      #     product.tags.merge!(tag_hsh) if kv_inequality?(product.tags, k, tag_hsh[k])
      #   end
      # end
      product.tags = tag_hsh
      product.save
    end

  end
end
