module ElementType
  extend BuildSet
  #ElementType.populate

  def self.populate
    set = []
    type_modules.each do |mojule|
      mojule.option_group.each do |konstant|
        scoped_constant = to_scoped_constant(mojule, konstant)
        element_attrs = attr_values(scoped_constant)
        set << element_attrs
        element = find_or_create_by(element_attrs)
        if options = option_values(scoped_constant)
          options.each do |option_name|
            find_or_create_by_and_assoc(origin: element, kind: "#{element_attrs[:kind]}-option", name: option_name)
          end
        end
      end
    end
    set
  end

  #type_modules; element_types
  def self.type_modules
    [Category, Medium, Material, Mounting, Dimension, Edition]
  end

  #element_kinds;
  def self.hyph_type_names
    type_modules.map {|type| format_attr(type.to_s.underscore)}
  end

  #sub_type_names
  def self.option_groups
    type_modules.map {|mojule| mojule.option_group.map {|konstant| to_scoped_constant(mojule, konstant).name}}
  end

  #scoped_options
  def self.option_values(scoped_constant)
    scoped_constant.options if scoped_constant.singleton_methods.include?(:options)
  end

  # def self.sub_option_values(scoped_constant)
  #   scoped_constant.options if scoped_constant.singleton_methods.include?(:sub_options)
  # end
end
