class ElementBuild
  include BuildSet
  include ScopeBuild
  # ElementBuild.pop_origin_types
  # ElementBuild.pop_origin_classes
  # ElementBuild.pop_option_set_classes

  def self.pop_origin_types
    origin_types.map {|origin_type_name| [origin_type_name, find_or_create_by(scope_context(origin_type_name).element_attrs)]}
  end

  def self.pop_origin_classes
    set =[]
    pop_origin_types.each do |origin_type_set|
      file_names(origin_type_set[0]).each do |origin_class_name|
        origin_class = find_or_create_by(scope_context(origin_class_name).element_attrs)
        assoc_unless_included(origin: origin_type_set[1], target: origin_class)
        set << [origin_class_name, origin_class]
      end
    end
    set
  end

  def self.pop_option_set_classes
    pop_origin_classes.each do |origin_class_set|
      pos_zero_class_name, pos_zero_obj = origin_class_set[0], origin_class_set[1]
      [:OptionGroup, :AssocGroup].each do |filter_class|
        const_hash = filter_const_hash(pos_zero_class_name, filter_class)
        if const_hash.has_key?(to_key(filter_class))
          [const_hash[to_key(filter_class)][:pos_one_set], const_hash[to_key(filter_class)][:pos_two_set]].transpose.each do |option_group_set|
            pos_one_obj, pos_two_class = find_or_create_by(option_group_set.first.element_attrs), option_group_set.last
            assoc_unless_included(origin: pos_zero_obj, target: pos_one_obj)
            pop_options(pos_one_obj, pos_two_class, filter_class)
          end
        end
      end
    end
  end

  def self.pop_options(pos_one_obj, pos_two_class, filter_class)
    pos_two_class.option.each do |option_set|
      key_obj, value_scope = find_or_create_by(option_set.first), option_set.last
      assoc_unless_included(origin: pos_one_obj, target: key_obj)
    end
  end

  def self.pop_values(key_obj, value_scope, filter_class)
    pos_two_class.option.each do |option_set|
      key_obj, value_scope, pop_method = find_or_create_by(option_set.first), option_set.last, ['pop', to_snake(filter_class), 'value_set'].join('_').to_sym
      assoc_unless_included(origin: pos_one_obj, target: key_obj)
      public_send(pop_method, key_obj, value_scope)
    end
  end

  def self.pop_option_group_value_set(key_obj, value_scope)
    value_scope.option.map {|option_value_name| find_or_create_by(value_scope.option_value_attrs(option_value_name))}.each do |option_value_obj|
      assoc_unless_included(origin: key_obj, target: option_value_obj)
    end
  end

  def self.pop_assoc_group_value_set(key_obj, value_scope)
    value_scope.option.map {|assoc_class| find_or_create_by(assoc_class.element_attrs)}.each do |assoc_value_obj|
      assoc_unless_included(origin: key_obj, target: assoc_value_obj)
    end
  end

  # option class collection & validation methods ######################################

  # ElementBuild.filter_const_hash('painting', :OptionGroup) , vars: # pos_zero_scope, pos_zero_classes, opts, sets = scope_context(pos_zero_class_name), scope_context(pos_zero_class_name).constants, {}, {const_set: [], filter_set: []}
  def self.filter_const_hash(pos_zero_class_name, *filter_consts)
    if scope_context(pos_zero_class_name).constants.any? then pos_zero_scope, pos_one_class_names, opts, sets = scope_context(pos_zero_class_name), scope_context(pos_zero_class_name).constants, {}, {pos_one_set: [], pos_two_set: []} else return end
    filter_consts.each do |filter_class|
      pos_one_class_names.each do |pos_one_class_name|
        if class_set = pos_one_hsh_if_valid_option_class?(scope_context(pos_zero_class_name, pos_one_class_name), filter_class) # pass in as :symbol?
          opts[to_key(filter_class)] = sets
          opts[to_key(filter_class)][:pos_one_set] << class_set[0]
          opts[to_key(filter_class)][:pos_two_set] << class_set[1]
        end
      end
    end
    opts
  end

  def self.native_option_classes
    native_option_class(current_file, :OptionGroup, :AssocGroup)
  end

  def self.native_option_class(file_name, *filter_consts)
    opt_set = filter_consts.map {|filter_const| filter_const_hash(file_name, filter_const)}
    opt_set.map {|opt_hash| filter_consts.map {|filter| opt_hash[to_key(filter)][:pos_one_set] if opt_hash.has_key?(to_key(filter))}}.flatten.compact.uniq
  end

  def self.pos_one_hsh_if_valid_option_class?(pos_one_scope, filter_class)
    if pos_two_scope = pos_two_scope_if_valid?(pos_one_scope, filter_class)
      [pos_one_scope, pos_two_scope] if options_exists?(pos_two_scope)
    end
  end

  def self.pos_two_scope_if_valid?(pos_one_scope, filter_class)
    scope_context(pos_one_scope, filter_class) if pos_one_scope.const_defined?(filter_class) && method_exists?(scope_context(pos_one_scope, filter_class), :option)
  end

  def self.method_exists?(klass, method)
    klass.methods(false).include?(method)
  end

  def self.options_exists?(klass)
    klass.option.present?
  end

  # scope methods ##############################################################

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

  # folder_nameectory & file methods ###################################################

  def self.origin_types
    file_names('element_type')
  end

  def self.origin_classes
    origin_types.map {|type| file_names(type)}.flatten
  end

  def self.file_names(folder_name)
    Dir.glob("#{Rails.root}/app/models/element/#{folder_name}/*.rb").map {|path| path.split("/").last.split(".").first}
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

# END of used top level class





# Do not Delete!
# # attr methods ###############################################################
# # ThreeDimension::.option_value_attrs('weight')
# def self.element_attrs
#   h = {kind: element_kind, name: element_name, tags: element_tags}
# end
#
# def self.option_value_attrs(name)
#   option_value_attrs = element_attrs
#   option_value_attrs[:name] = name
#   option_value_attrs
# end
#
# def self.element_kind
#   [element_type, option_type].join('-')
# end
#
# def self.element_name
#   name = decamelize(slice_class(-1))
#   if name == 'option group'
#     [decamelize(origin), 'option'].join(' ')
#   else
#     name
#   end
# end
#
# def self.element_tags
#   h= {element_type: element_type, option_type: option_type}
#   #h[:product_name] = product_name(element_name) if slice_class(-1).to_s == 'OptionGroup'
#   h
# end
#
# def self.assoc_key_attrs(assoc)
#   if decamelize(slice_class(-1),'_') == 'assoc_group'
#     h = {kind: [assoc.to_s, 'assoc-key'].join('-'), name: [decamelize(origin), assoc.to_s, 'assoc-option'].join(' '), tags: {origin_type: element_type, target_type: assoc.to_s, option_type: option_type}}
#   end
# end
#
# # def self.option_value_attrs(name)
# #   if decamelize(slice_class(-1),'_') == 'assoc_group'
# #     h = {kind: [assoc.to_s, 'assoc-key'].join('-'), name: [decamelize(origin), assoc.to_s, 'assoc-option'].join(' '), tags: {origin_type: element_type, target_type: assoc.to_s, option_type: option_type}}
# #   end
# # end
#
# def self.element_type
#   if ['OptionValue', 'AssocValue'].include?(slice_class(-1))
#     current_file
#   else
#     current_dir
#   end
# end
#
# def self.option_values
#   scope_context(current_dir, origin, 'option_value')
# end
#
# def self.assoc_values
#   scope_context(current_dir, origin, 'assoc_value')
# end
#
# def self.option_type
#   if origin_types.include?(current_file) && slice_class(-1).to_s != 'OptionValue' && slice_class(-1).to_s != 'AssocValue'
#     option_types[0]
#   elsif origin_classes.include?(decamelize(klass_name, '_'))
#     option_types[1]
#   elsif self.constants.include?(:OptionGroup)
#     option_types[2]
#   elsif slice_class(-1).to_s == 'OptionGroup'
#     option_types[3]
#   elsif slice_class(-1).to_s == 'AssocGroup'
#     option_types[4]
#   elsif slice_class(-1).to_s == 'OptionValue'
#     option_types[5]
#   end
# end

# maybe this too!

# # origin_class: pos_zero, const: pos_one, filter_consts: pos_two # -> filter_consts -> needs to be Camel symbol
# def self.filter_consts(pos_zero_class, *filter_consts)
#   return if scope_context(pos_zero_class).constants.none?
#   opts, sets = {}, {const_set: [], filter_set: []}
#   #filter_conts.map {|filter_cont| opts[to_key(filter_cont)] = sets}
#   filter_consts.each do |filter_const|
#     scope_context(pos_zero_class).constants.each do |pos_one_class|
#
#       if scope_context(pos_zero_class, pos_one_class).const_defined?(filter_const)
#
#         opts[to_key(filter_const)] = sets
#         opts[to_key(filter_const)][:const_set] << scope_context(pos_zero_class, pos_one_class)
#         opts[to_key(filter_const)][:filter_set] << scope_context(pos_zero_class, pos_one_class, filter_const)
#       end
#     end
#   end
#   opts
# end

# def self.filtered_classes(origin_class, filter_class, opt_class = false, set=[])
#   scope_context(origin_class).constants.each do |konstant|
#     if scope_context(origin_class, konstant).const_defined?(filter_class)
#       set << scope_context = opt_class == true ? scope_context(origin_class, konstant, filter_class) : scope_context(origin_class, konstant)
#     end
#   end
#   set
# end

# below this line is likely stuff to kill

############################################################################## search methods

# def self.search_text
#   element_name.pluralize
# end
#
# def self.search_value
#   slice_class(-1).to_s.underscore.to_sym
# end
