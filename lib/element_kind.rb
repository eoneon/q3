module ElementKind
  extend BuildSet

  def self.pop_elements
    #set =[]
    self.constants.each do |konstant|
      kind = to_snake(konstant) #used for find_or_create_by
      scoped_constant = scoped_constant(konstant)
      scoped_constant.instance_methods(false).each do |instance_method|
        tag_key = instance_method.to_s
        scoped_constant.new.public_send(instance_method).each do |element_name|
          element = find_or_create_by(kind: kind, name: element_name)
          update_tags(element, h ={tag_key => 'true'})
      		# if element.tags.nil? || element.tags[tag_key] != 'true'
      		#   element.tags.merge!(h ={tag_key => 'true'})
      		#   element.save
      		# end
        end
      end
    end
  end

  def self.update_tags(element, tag_hsh)
    #element.tags ={} if element.tags.nil?
    if element.tags.nil?
      element.tags = tag_hsh
      element.save
    elsif !element.tags.has_key?(tag_hsh.keys.first)
      element.tags.merge(tag_hsh)
      element.save
    end
  end
  # def self.klasses
  #   self.constants.map {|kind| [kind, [self.name, kind].join('::')]}
  # end
  #=> [[:Medium, "ElementKind::Medium"], [:Material, "ElementKind::Material"], [:Edition, "ElementKind::Edition"], [:Signature, "ElementKind::Signature"], [:Certificate, "ElementKind::Certificate"], [:Dimension, "ElementKind::Dimension"], [:Mounting, "ElementKind::Mounting"]]

  # ElementKind.pop_elements
  # def self.pop_elements
  #   set =[]
  #   self.constants.each do |konstant|
  #     #element_tags ={}
  #     kind = to_snake(konstant)
  #     scoped_constant = scoped_constant(konstant)
  #     tags = scoped_constant.instance_methods(false)
  #
  #     #names = tags.map {|tag| scoped_constant.new.public_send(tag)}.flatten.uniq
  #     grouped_element_names = tags.map {|tag| scoped_constant.new.public_send(tag)}
  #
  #     grouped_element_names.flatten.uniq.each do |element_name|
  #       h ={}
  #     #names.each do |name|
  #       #tags.map {|tag| element_tags.merge!(h ={"#{tag}" => "true"}) if scoped_constant.new.public_send(tag).include?(name)}
  #       #tags.map {|tag| element_tags.merge!(h ={"#{tag}" => "true"}) if scoped_constant.new.public_send(tag).include?(element_name)}
  #       grouped_element_names.map {|element_group| }
  #       set << element_name
  #       #element = find_or_create_by(kind: kind, name: name)
  #     end
  #     #set << to_constant([self.name, konstant].join('::')).new
  #     #set << scoped_constant(konstant).new
  #
  #   end
  #   set
  # end
  #
  # def self.check(element_group, name, h)
  #   if value = element_group.include?(name)
  #     h.merge!(h ={"#{scope}" => "#{value}"})
  #     h[]
  #     #puts "element_tags[#{scope}] = #{value}"
  #   end
  # end
  # module Test
  #   module Test2
  #   end
  # end

  class Medium
    def primary
      %w[painting drawing mixed-media print sericel sculpture hand-blown hand-made]
    end

    def secondary
      %w[embellished hand-pulled sculpture-type]
    end

    def tertiary
      %w[leafing remarque]
    end

    def component
      %w[diptych triptych quadriptych set]
    end

    def category
      %w[original one-of-a-kind production limited-edition single-edition open-edition]
    end
  end

  class Material
    def standard
      %w[canvas paper board metal]
    end

    def photography
      %w[photography-paper]
    end

    def sericel
      %w[sericel]
    end

    def sculpture
      %w[glass ceramic metal synthetic]
    end

    def hand_blown
      %w[glass]
    end

    def hand_made
      %w[ceramic]
    end
  end

  class Edition
    def limited
      %w[numbered-xy numbered from-an-edition]
    end

    def single
      %w[single-edition]
    end

    def open
      %w[open-edition]
    end
  end

  class Signature
    def standard
      %w[artist relative celebrity]
    end

    def three_d
      %w[artist-3d]
    end
  end

  class Certificate
    def standard
      %w[standard-certificate publisher-certificate]
    end

    def animation
      %w[animation-seal sports-seal animation-certificate]
    end
  end

  class Dimension
    def two_d
      %w[width height]
    end

    def three_d
      %w[width height depth]
    end
  end

  class Mounting
    def two_d
      %w[framed bordered matted wall-mount]
    end

    def three_d
      %w[case base wall-mount]
    end
  end
end
