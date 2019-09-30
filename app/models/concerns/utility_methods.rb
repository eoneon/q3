require 'active_support/concern'

module UtilityMethods
  #include Element
  extend ActiveSupport::Concern
  included do
    def to_snake(obj)
      if obj.class == String
        obj.underscore.singularize
      elsif obj.class == Symbol
        obj.to_s.underscore.singularize
      else
        obj.class.name.underscore
      end
    end
    def find_or_create_by_name(obj_klass:, name:)
      to_konstant(obj_klass).where(name: name).first_or_create
    end

    def find_or_create_by_names(obj_klass:, names:)
      objs = []
      names.each do |name|
        objs << find_or_create_by_name(obj_klass: obj_klass, name: name)
      end
      return objs
    end

    def find_or_create_by_name_and_assoc(origin:, target_type:, target_name:)
      target = find_or_create_by_name(obj_klass: target_type, name: target_name)
      assoc_unless_included(origin, target)
      return target
    end

    def assoc_target_and_origins_via_name_set(origin_klass:, origin_names:, target:)
      origin_set = find_or_create_by_names(obj_klass: origin_klass, names: origin_names)
      origin_set.map {|origin| assoc_unless_included(origin, target)}
    end

    def find_or_create_by_names_and_assoc(origin:, target_type:, target_names:)
      targets =[]
      target_names.each do |target_name|
        target = find_or_create_by_name(obj_klass: target_type, name: target_name)
        targets << target
        assoc_unless_included(origin, target)
      end
      return targets
    end

    def find_or_create_by_name_and_assoc_many(origins:, target_type:, target_name:)
      target = find_or_create_by_name(obj_klass: target_type, name: target_name)
      origins.map {|origin| assoc_unless_included(origin, target)}
      return target
    end

    def find_origin_kollection_by_name(origin_name:, origin_type:, target_type:)
      origin = find_or_create_by_name(obj_klass: origin_type, name: origin_name)
      has_kollection?(origin, target_type)
    end

    def assoc_unless_included(origin, target)
      to_kollection(origin, target) << target unless to_kollection(origin, target).include?(target)
    end

    def assoc_kollection(origin:, target_type:, targets:)
      to_kollection(origin, target_type) << targets
      targets.map {|target| to_kollection(origin, target_type) << target}
    end

    def has_kollection_ids?(origin, target_type)
      if kollection = has_kollection?(origin, target_type)
        kollection.pluck(:id)
      end
    end

    #new
    def assoc_nested_origins_and_target_set(origin:, hm_assoc:, target_set:)
      target_set.each do |set|
        target = find_or_create_by_name(obj_klass: set[0], name: set[1])
        #Category(name: 'Flat-Material').materials
        to_kollection(origin, hm_assoc).map {|nested_origin| assoc_unless_included(nested_origin, target)}
      end
    end

    ##################################################### object based: build methods:
    def assoc_origins_and_target_set(origins:, targets:)
      origins.each do |origin|
        assoc_targets(origin: origin, targets: targets)
      end
    end

    def assoc_targets(origin:, targets:)
      targets.map {|target| assoc_unless_included(origin, target)}
    end
  end
end
