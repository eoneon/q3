class BuildElement
  extend BuildAppData

  # def self.element_types
  #   ElementType.constants.map {|type| to_snake(type)}
  # end

  def self.element_types_and_constants
    ElementType.types_and_constants.map {|set| [to_snake(set[0]), to_constant(set[1])]}
  end

  def build_elements
    element_types_and_constants.each do |type_and_constant| #medium
      type, konstant = type_and_constant[0], type_and_constant[1]
      element_tags = {'type' => type} #medium
      #names = to_constant(type).names
      names = konstant.names
      names.each do |name|
        #element_tags = build_boolean_tags(name, element_tags, to_constant(type).boolean_tags)
        element_tags = build_boolean_tags(name, element_tags, konstant.boolean_tags)
        #element_tags = build_text_tags(name, element_tags, to_constant(type).text_tags)
        element_tags = build_text_tags(name, element_tags, konstant.text_tags)
        element = find_or_create_by_name(klass: :element, name: name)
        update_tags(element, element_tags)
      end
    end
  end

  def build_boolean_tags(name, element_tags, boolean_tags)
    boolean_tags.each do |tag|
      if public_send(tag).include?(name)
        element_tags[tag] = 'true'
      end
    end
    element_tags
  end

  def build_text_tags(name, element_tags, text_tags)
    text_tags.each do |tag_set|
      tag = tag_set.first
      tag_set.drop(1).each do |set|
        if set.include?(name)
          return element_tags[tag] = set.first
        end
      end
    end
  end

  def update_tags(element, element_tags)
    if element.tags != element_tags
      element.tags = element_tags
      element.save
    end
  end
end
