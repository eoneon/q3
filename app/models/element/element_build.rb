class ElementBuild
  #ElementBuild.origin_zero_set, ElementBuild.origin_one_set, ElementBuild.origin_two_set
  #ElementBuild.origin_classes #ElementBuild.subtype_classes, #ElementBuild.file_names('category')

  #ElementType: element/element_type: #=> ["category", "edition", "medium", "material"]
  def self.origin_zero_set
    #origin_types.map {|origin_zero_name| [origin_zero_name, find_or_create(scope_context(origin_zero_name).element_attrs)]}
    origin_types.map {|origin_zero_name| [origin_zero_name, scope_context(origin_zero_name).element_attrs]}
    #origin_types.map {|origin_zero_name| origin_zero_name}
  end

  #ElementBuild.origin_one_set
  def self.origin_one_set
    set =[]
    origin_zero_set.each do |origin_set|
      #origin_zero = origin_set[1]
      file_names(origin_set[0]).each do |origin_one_name|
        origin_one_name = [origin_one_name, scope_context(origin_one_name).element_attrs] #test
        #origin_one = find_or_create(scope_context(origin_one_name).element_attrs)
        #assoc_unless_included(origin: origin_set[1], target: origin_one)
        #set << [origin_one_name, origin_one]
        set << origin_one_name #test
      end
    end
    set
  end

  #ElementBuild.origin_two_set -> OptionGroup
  def self.origin_two_set
    set =[]
    origin_one_set.each do |origin_set|
      scope_context(origin_set[0]).constants.each do |origin_two_name|
        scope_context = scope_context(origin_set[0], origin_two_name)
        #origin_two = find_or_create(scope_context.element_attrs)
        origin_two = scope_context.element_attrs #test
        #assoc_unless_included(origin: origin_set[1], target: origin_two)
        #set << [origin_two_name, origin_two]
        set << [origin_two_name] #test
      end
    end
    set
  end

  # build methods ###############################################################

  def self.option_group_set(origin_class, set =[])
    if option_group_classes(origin_class).any?
      return build_option_group_set(origin_class, set)
    end
  end

  def self.build_option_group_set(origin_class, set)
    option_group_classes(origin_class).each do |option_group_class|
      option_group_class.option.each do |option_set|
        set << [option_set.first, option_set.last]
      end
    end
    set
  end

  def self.assoc_group_set(origin_class, set =[])
    if assoc_group_classes(origin_class).any?
      return build_assoc_group_set(origin_class, set)
    end
  end

  def self.build_assoc_group_set(origin_class, set)
    assoc_group_classes(origin_class).each do |assoc_group_class|
      assoc_group_class.option.each do |option_set|
        set << [option_set.first, option_set.last]
      end
    end
    set
  end

  # attr methods ###############################################################

  def self.element_attrs
    h = {kind: element_kind, name: element_name, tags: element_tags}
  end

  def self.element_kind
    [element_type, option_type].join('-')
  end

  def self.element_name
    name = decamelize(slice_class(-1))
    if name == 'option group'
      [decamelize(origin), 'option'].join(' ')
    else
      name
    end
  end

  def self.element_tags
    h= {element_type: element_type, option_type: option_type}
    #h[:product_name] = product_name(element_name) if slice_class(-1).to_s == 'OptionGroup'
    h
  end

  def self.assoc_key_attrs(assoc)
    if decamelize(slice_class(-1),'_') == 'assoc_group'
      h = {kind: [assoc.to_s, 'assoc-key'].join('-'), name: [decamelize(origin), assoc.to_s, 'assoc-option'].join(' '), tags: {origin_type: element_type, target_type: assoc.to_s, option_type: option_type}}
    end
  end

  def self.element_type
    current_file #.split('_').join('-')
  end

  def self.option_type
    if origin_types.include?(current_file)
      'origin-type'
    elsif origin_classes.include?(decamelize(klass_name, '_'))
      'origin-class'
    elsif filtered_classes(current_file, :OptionGroup).include?(self)
      'option-group'
    elsif slice_class(-1).to_s == 'OptionGroup'
      'option-key'
    elsif slice_class(-1).to_s == 'AssocGroup'
      'assoc-key'
    end
  end

  # folder_nameectory & file methods ###################################################

  def self.origin_types
    file_names('element_type')
  end

  def self.origin_classes
    origin_types.map {|type| file_names(type)}.flatten
  end

  def self.option_group_classes(origin_class)
    scope_context(origin_class).constants.map {|konstant| scope_context(origin_class, konstant, :OptionGroup) if scope_context(origin_class, konstant).const_defined?(:OptionGroup)}.reject {|i| i.nil?}
  end

  def self.assoc_group_classes(origin_class)
    scope_context(origin_class).constants.map {|konstant| scope_context(origin_class, konstant, :AssocGroup) if scope_context(origin_class, konstant).const_defined?(:AssocGroup)}.reject {|i| i.nil?}
  end

  def self.file_names(folder_name)
    Dir.glob("#{Rails.root}/app/models/element/#{folder_name}/*.rb").map {|path| path.split("/").last.split(".").first}
  end

  # scope methods ##############################################################

  #ElementBuild.scoped_classes(Painting, :OptionGroup)
  def self.filtered_classes(origin_class, filter_class)
    scope_context(origin_class).constants.map {|konstant| scope_context(origin_class, konstant) if scope_context(origin_class, konstant).const_defined?(filter_class)}.reject {|i| i.nil?}
  end

  def self.scope_context(*konstant_objs)
    set=[]
    konstant_objs.each do |konstant_obj|
      if konstant_obj.to_s.index('::')
        konstant_obj.to_s.split('::').map {|konstant| set << konstant}
      else
        set << format_constant(konstant_obj)
      end
    end
    set.join('::').constantize
  end

  def self.format_constant(konstant)
    konstant.to_s.split(' ').map {|word| word.underscore.split('_').map {|split_word| split_word.capitalize}}.flatten.join('')
  end

  # parse scope chain relative to self #########################################

  def self.klass_name
    slice_class(-1)
  end

  def self.slice_class(*i)
    i.empty? ? self.to_s : self.to_s.split('::')[i.first]
  end

  def self.origin
    self.superclass.to_s.split('::')[-1]
  end

  def self.super_origin
    self.superclass.superclass.to_s.split('::')[-1]
  end

  # utility methods ############################################################

  def self.decamelize(camel_word, *delim)
    delim = delim.empty? ? ' ' : delim.first
    name_set = camel_word.to_s.underscore.split('_')
    name_set.join(delim)
  end

end

# scope_context(scope_context, 'assoc_group').option.each do |assoc_set|
#   assoc_set.each do |set|
#     assoc_key = find_or_create_by(set.first) #[origin_two.name, assoc-key].join('-') -> kind: "original-assoc-key", name: "original-medium-option"
#     assoc_unless_included(origin: origin_two, target: assoc_key)
#
#     set.last.map {|assoc_class| find_or_create_by(scope_context(assoc_class).element_attrs)}.each do |assoc_opt|
#       assoc_unless_included(origin: assoc_key, target: assoc_opt)
#     end
#   end
# end

# def self.populate
#   set =[]
#   #Part 1: option-group-origin
#   #element/element_type: #=> ["category", "edition", "medium", "material"]
#   origin_types.each do |origin_zero_name|
#     origin_zero = find_or_create(scope_context(origin_zero_name).element_attrs)
#
#     #Part 2: option-group
#     #element/category: #=> ["print_art", "original_art", "sculpture", "limited_edition"]
#     #element/medium: #=> ["mixed_medium", "standard_print", "painting", "unique_sculpture", "drawing", "basic_print", "standard_sculpture", "limited_edition_print"]
#     #element/material: #=> ["canvas", "paper"]
#     file_names(origin_zero_name).each do |origin_one_name| #["original_art"...]
#       origin_one = find_or_create(scope_context(origin_one_name).element_attrs)
#       assoc_unless_included(origin: origin_zero, target: origin_one) #category << original_art
#
#       #Part 3: option
#       #PrintArt.constants #=> []
#       #OriginalArt.constants #=> [:Original, :OneOfAKind],...
#       #Sculpture.constants #=> []
#       #LimitedEdition.constants #=> []
#       scope_context(origin_one_name).constants.each do |origin_two_name| #Original, OneOfAKind
#         scope_context = scope_context(origin_one_name, origin_two_name)
#         origin_two = find_or_create(scope_context.element_attrs)
#         assoc_unless_included(origin: origin_one, target: origin_two) #original_art << Original
#
        # #Part 4: assoc-key: assoc-value
        # #if scope_context.constant_names.include?('assoc_target')
        # scope_context(scope_context, 'assoc_group').option.each do |assoc_set|
        #   assoc_set.each do |set|
        #     assoc_key = find_or_create_by(set.first) #[origin_two.name, assoc-key].join('-') -> kind: "original-assoc-key", name: "original-medium-option"
        #     assoc_unless_included(origin: origin_two, target: assoc_key)
        #
        #     set.last.map {|assoc_class| find_or_create_by(scope_context(assoc_class).element_attrs)}.each do |assoc_opt|
        #       assoc_unless_included(origin: assoc_key, target: assoc_opt)
        #     end
        #   end
        # end
#
#         #Part 5: option-key: option-value
#         #if scope_context.constant_names.include?('option_value')
#         scope_context(scope_context, 'option_group').option.each do |option_set|
#           option_set.each do |set|
#             option_key = find_or_create_by(set.first) #[origin_two.name, assoc-key].join('-') -> kind: "original-assoc-key", name: "original-medium-option"
#             assoc_unless_included(origin: origin_two, target: option_key)
#
#             set.last.map {|option_name| find_or_create_by(scope_context(scope_context, 'option_group').element_attrs)}.each do |option_value|
#               assoc_unless_included(origin: option_key, target: option_value)
#             end
#           end
#         end
#       end
#     end
#   end
#   set
# end

############################################################################## search methods

# def self.search_text
#   element_name.pluralize
# end
#
# def self.search_value
#   slice_class(-1).to_s.underscore.to_sym
# end

# def self.decamelize(camel_word, *n)
#   word_count = n.empty? ? 0 : n.first
#   name_set = camel_word.to_s.underscore.split('_')
#   name_set.count >= word_count ? name_set.join('-') : name_set.join(' ')
# end

# def option_sets
#   option_group.map {|klass| [scope_context(self, klass).name, scope_context(self, klass).option_set.map {|set| [set.to_s, EditionType.public_send(set)]}]}
# end

# def self.get_folder #(folder_name)
#   #__folder_name__#folder_name.glob("#{Rails.root}/app/models/element/#{folder_name}/*.rb")
#   #File.basename(folder_name.pwd)
#   #File.basename()
#   #File.basename(__FILE__, ".rb") #=> "element_build"
# end
