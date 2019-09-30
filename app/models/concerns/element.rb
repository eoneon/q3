require 'active_support/concern'

module Element
  extend ActiveSupport::Concern

  class_methods do

    def scoped_types
      types.map{|type| public_send(type.underscore.singularize).prepend(type)}
    end

    def names
      scoped_types.map {|set| set.drop(1)}.flatten.uniq
    end

    # def find_or_create_scoped_elements_and_assoc(origin, kind, *names)
    #   names.each do |name|
    #     target = find_or_create_by_name(obj_klass: :element, name: name)
    #     if target.kind != kind
    #       target.kind = kind
    #       target.save
    #     end
    #     assoc_unless_included(origin, target)
    #   end
    # end

    # def baz
    #   puts 'hello'
    # end
  end
end
