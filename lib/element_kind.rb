module ElementKind
  extend BuildSet
  extend HashTag

  def self.pop_elements
    text_tag_konstants =[]

    self.constants.each do |konstant| #Medium
      text_tag_konstants << konstant if scoped_constant(konstant).constants.include?(:TextTag)
      scoped_constant(konstant, :BooleanTag).instance_methods(false).each do |instance_method|
        #ElementKind::Medium::BooleanTag.instance_methods => primary...
        scoped_constant(konstant, :BooleanTag).new.public_send(instance_method).each do |value|
          element = find_or_create_by(kind: to_snake(konstant), name: value)
          update_tags(element, h ={instance_method.to_s => 'true'})
        end
      end
      #
    end
    elements = Element.where(kind: text_tag_konstants.map{|konstant| to_snake(konstant)})
    text_tag_konstants.each do |konstant|
      scoped_constant(konstant, :TextTag).instance_methods(false).each do |instance_method|
        scoped_constant(konstant, :TextTag).new.public_send(instance_method).each do |set|
          elements.where(kind: to_snake(konstant)).each do |element|
            if set.include?(element.name)
              update_tags(element, h = {to_snake(instance_method) => set.first})
            end
          end
        end
      end
    end
  end
  # def self.pop_elements
  #   self.constants.each do |konstant|
  #     #scoped_constant = scoped_constant(konstant)
  #     scoped_constant = scoped_constant(konstant, 'BooleanTag')                           #ElementKind::Medium
  #     scoped_constant.instance_methods(false).each do |instance_method|
  #       scoped_constant.new.public_send(instance_method).each do |element_name|
  #         element = find_or_create_by(kind: kind = to_snake(konstant), name: element_name)
  #         element = update_tags(element, h ={instance_method.to_s => 'true'})
  #       end
  #     end
  #
  #     if scoped_constant(konstant).constants.include?(:TextTag)
  #       scoped_constant = scoped_constant(konstant, 'TextTag') #ElementKind::Medium::TextTag
  #       scoped_constant.instance_methods(false).each do |instance_method| #material_type/tag_key
  #
  #         scoped_element_names = scoped_constant.new.public_send(instance_method)
  #         if scoped_element_names.include?(element.name)
  #           update_tags(element, h = {to_snake(instance_method) => scoped_element_names.first})
  #         end
  #       end
  #     end
  #   end
  # end

  # def self.pop_elements
  #   @elements =[]
  #   self.constants.each do |konstant| #Medium
  #     #ElementKind::Medium.constants
  #     scoped_constant(konstant).constants.each do |tag_scope| #:BooleanTag
  #       #ElementKind::Medium::BooleanTag.instance_methods
  #       # => primary/material_type
  #       scoped_constant(konstant, tag_scope).instance_methods(false).each do |instance_method|
  #         #ElementKind::Medium::BooleanTag.primary
  #           #=> %w[painting drawing...]
  #         #ElementKind::Medium::BooleanTag.material_type
  #           #=> [%w[painting drawing mixed-media print].prepend('standard'),...]
  #         scoped_constant(konstant, tag_scope).new.public_send(instance_method).each do |value|
  #           if tag_scope == :BooleanTag
  #             element = find_or_create_by(kind: to_snake(konstant), name: value)
  #             @elements << update_tags(element, h ={instance_method.to_s => 'true'})
  #           elsif tag_scope == :TextTag
  #             #puts "#{value}"
  #             #puts "#{@element.name}"
  #             element = @elements.last
  #             if value.include?(element.name)
  #               #puts "#{value}.include?(#{@element.name})"
  #               update_tags(element, h = {to_snake(instance_method) => value.first})
  #             end
  #           end
  #           @elements
  #         end
  #       end
  #     end
  #   end
  #   @elements
  # end

  module Medium
    class BooleanTag
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

    class TextTag
      def material_type
        [%w[painting drawing mixed-media print].prepend('standard'), %w[photography], %w[sericel], %w[hand-blown], %w[hand-made], %w[sculpture]]
      end
    end
  end

  module Material
    class BooleanTag
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
  end

  module Edition
    class BooleanTag
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
  end

  module Signature
    class BooleanTag
      def standard
        %w[artist relative celebrity]
      end

      def three_d
        %w[artist-3d]
      end
    end
  end

  module Certificate
    class BooleanTag
      def standard
        %w[standard-certificate publisher-certificate]
      end

      def animation
        %w[animation-seal sports-seal animation-certificate]
      end
    end
  end

  module Dimension
    class BooleanTag
      def two_d
        %w[width height]
      end

      def three_d
        %w[width height depth]
      end
    end
  end

  module Mounting
    class BooleanTag
      def two_d
        %w[framed bordered matted wall-mount]
      end

      def three_d
        %w[case base wall-mount]
      end
    end
  end
end
