module ElementGroup
  extend BuildSet
  #ElementGroup.pop_options
  def self.element_kinds
    ElementSet.constants.map{|konstant| to_snake(konstant)}
  end

  def self.pop_options
    elements = Element.where(kind: element_kinds)
    element_kinds.each do |element_kind| #'signature'
      to_constant([ElementSet, element_kind.classify].join('::')).instance_methods(false).each do |instance_method|
      #scoped_konstant(ElementSet, element_kind).instance_methods(false).each do |instance_method|  #[:flat_signature,...]
        option_name_set = to_constant([ElementSet, element_kind.classify].join('::')).new.public_send(instance_method)
        #option_name_set = scoped_konstant(ElementSet, element_kind).new.public_send(instance_method)
        option_set = option_set(option_name_set)
        option_group = find_or_create_by(kind: 'option-group', name: instance_method.to_s)
        update_tags(option_group, h={"option_type" => element_kind})
        build_option_group(option_group, option_set)
        puts "wtf"
      end
    end
  end

  def self.option_set(option_name_set)
    set =[]
    option_name_set.each do |name_set|
      set << Element.find_by(name: name_set).to_a
    end
    set
  end

  def self.build_option_group(option_group, option_set)
    if option_group.elements.none?
      create_all(option_group, option_set)
    else
      create_missing(option_group, option_set, option_group.elements.to_a)
    end
  end

  def self.create_all(option_group, option_set)
    option_set.each do |target_set|
      build_option(option_group, target_set)
    end
  end

  def self.create_missing(option_group, option_set, existing_set)
    option_set.each do |target_set|
      if existing_set.exclude?(target_set)
        build_option(option_group, target_set)
      end
    end
  end

  def self.build_option(option_group, target_set)
    name = arr_to_text(target_set.map(&:name))
    option = find_or_create_by(kind: 'option', name: name)
    update_tags(option, h={"option_type" => "signature"})
    #option.elements << target_set
    target_set.map {|target| option.elements << target}
    option_group.elements << option
  end

  ###############################################################################

  # ElementGroup.pop_signature_options
  # ElementGroup::Signature.instance_methods(false)
  def self.pop_signature_options
    signatures = Element.by_kind('signature')
    Signature.instance_methods(false).each do |instance_method| #[:flat_signature,...]
      #existing_set = existing_signature_options()
      option_group = find_or_create_by(kind: 'option-group', name: instance_method.to_s)
      update_tags(option_group, h={"option_type" => "signature"})
      #build_options
  	  if option_group.elements.any?
  	    create_missing(option_group, option_group.elements.to_a)
  	  else
  	    create_all(option_group)
  	  end
    end
  end



  def self.signature_option_set
    set =[]
    self.constants.each do |konstant|                                             #:Signature
      element_kind = to_snake(konstant)                                           #signature
      element_kinds = Element.by_kind(element_kind)                               #Element.by_kind(signature)
    	#to_constant(konstant).new.public_send(instance_method).each do |name_set|
      Signature.instance_methods(false).each do |instance_method|      #:flat_signature
        Signature.new.public_send(instance_method).each do |name_set| #[artist, artist]
  	      name_set.map {|name| set << element_kinds.where(name: name)}
        end
    	end
    end
  end
#this needs to be scoped and then called using .new
  def self.existing_signature_options(name)
    existing_set =[]
    #Element.by_option_group('signature').each do |option_group|
    Element.find_by(name: name).first.elements.each do |option|
      existing_set << option.elements.to_a if option.elements.any?
    end
    existing_set
  end

  # def self.create_missing(option_group, existing_set)
  #   existing_set.each do |target_set|
  #     if existing_set.exclude?(target_set)
  #       build_signature_option(option_group, target_set)
  #     end
  #   end
  # end
  #
  # def self.create_all(option_group)
  #   signature_option_set.each do |target_set|
  #     build_signature_option(option_group, target_set)
  #   end
  # end

  def self.build_signature_option(option_group, target_set)
    name = arr_to_text(target_set)
    option = find_or_create_by(kind: 'option', name: name)
    update_tags(option, h={"option_type" => "signature"})
    target_set.map {|option_name| option.elements << element_kinds.find_by(name: option_name)}
    option_group.elements << option
    #return option
  end
end
