module OptionGroup
  extend BuildSet

  def self.populate
    [Signature, Certificate].each do |option_constant|
      to_scoped_constant(option_constant, :option_group_set).instance_methods(false).each do |instance_method|
        elements = Element.where(kind: option_constant.to_s.underscore)
        option_group = find_or_create_by(kind: 'option-group', name: instance_method.to_s) #flat_signature
        update_tags(option_group, h={"option_type" => to_snake(option_constant.to_s)})
        option_set = option_set(elements, to_scoped_constant(option_constant, :option_group_set).new.public_send(instance_method))
        create_option_group(option_group, option_set)
      end
    end
  end

  def self.create_option_group(option_group, option_set)
    option_set.each do |option_elements|
      build_option_group(option_group, option_elements)
    end
  end

  def self.build_option_group(option_group, option_elements)
    name = arr_to_text(option_elements.map(&:name))
    option = find_or_create_by(kind: 'option', name: name)
    update_tags(option, h={"option_type" => option_group.tags["option_type"]})
    option.elements << option_elements if option.elements.none?
    assoc_unless_included(origin: option_group, target: option)
  end

  def self.option_set(elements, options)
    set =[]
    options.each do |name_set|
      set << elements.where(name: name_set).to_a
    end
    set
  end

end

  # def self.build_option_group(option_group, option_set)
  #   if option_group.elements.none?
  #     create_all(option_group, option_set)
  #   else
  #     create_missing(option_group, option_set)
  #   end
  # end
  #
  # def self.create_all(option_group, option_set)
  #   option_set.each do |target_set|
  #     build_option(option_group, target_set)
  #   end
  # end
  #
  # def self.create_missing(option_group, option_set)
  #   option_set.each do |target_set|
  #     if option_group.elements.exclude?(target_set)
  #       build_option(option_group, target_set)
  #     end
  #   end
  # end
  #
  # def self.build_option(option_group, target_set)
  #   name = arr_to_text(target_set.map(&:name))
  #   option = find_or_create_by(kind: 'option', name: name)
  #   update_tags(option, h={"option_type" => option_group.tags["option_type"]})
  #
  #   target_set.map {|target| option.elements << target}
  #   #option_group.elements << option #
  #   assoc_unless_included(origin: option_group, target: option)
  # end
