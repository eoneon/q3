class BuildElement
  extend BuildSet

  def self.element_kinds_and_constants
    ElementKind.kinds_and_constants.map {|set| [to_snake(set[0]), to_constant(set[1])]}
  end

  def self.pop_elements
    element_kinds_and_constants.each do |kind_and_constant| #medium
      element_tags, kind, konstant = {}, kind_and_constant[0], kind_and_constant[1]
      boolean_tags = konstant.boolean_tags
      #text_tags = konstant.text_tags

      konstant.names.each do |name|
        element = find_or_create_by(kind: kind, name: name)
        boolean_tags.map {|scope| check(konstant, to_snake(scope), name, element_tags)}
        #boolean_tags.map {|scope| element_tags[to_snake(scope)] = "true" if check(konstant, to_snake(scope), name)}
        #boolean_tags.map {|scope| element_tags[to_snake(scope)] = "true" if public_send([konstant, to_snake(scope)].join('.'))}
        # if konstant.respond_to?(:text_tags)
        #   build_text_tags(name, element_tags, text_tags)
        # end
        update_tags(element, element_tags)
      end

    end
  end

  def self.check(konstant, scope, name, element_tags)
    if value = konstant.public_send(scope).include?(name)
      element_tags.merge!(h ={"#{scope}" => "#{value}"})
      #puts "element_tags[#{scope}] = #{value}"
    end
  end

  # def self.build_boolean_tags(name, element_tags, boolean_sets)
  #   boolean_sets.each do |set|
  #     if set.include?(name)
  #       element_tags["#{set.first}"] = "true"
  #     end
  #   end
  #   element_tags
  # end

  def self.build_text_tags(name, element_tags, text_tags)
    text_tags.each do |tag_set|
      tag = tag_set.first
      tag_set.drop(1).each do |set|
        if set.include?(name)
          return element_tags[tag] = set.first
        end
      end
    end
  end

  def self.update_tags(element, element_tags)
    if element.tags != element_tags
      element.tags = element_tags
      element = element.save
    end
    element
  end
end
