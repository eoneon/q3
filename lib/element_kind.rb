module ElementKind
  extend BuildSet
  extend HashTag

  ################################################################ ElementKind.pop_products - ElementKind.existing_products - Element.where(kind: 'product').destroy_all - Element.readable_objs(set)

  # def self.pop_products
  #   existing_set = existing_products
  #   if existing_set.any?
  #     create_missing(existing_set)
  #   else
  #     create_all
  #   end
  # end
  #
  # def self.product_set
  #   product_groups, media =[], Element.by_kind('medium')
  #   Medium::TextTag.new.material_type.map{|set| set.first}.each do |material_type|
  #     media.primary_media.where("tags @> ?", ("material_type => #{material_type}")).each do |medium|
  #       ElementSet::Medium.set.each do |set|
  #         if set.include?(medium.name)
  #           media_group = media.where(name: set)
  #           scoped_materials = Element.by_kind('material').where("tags @> ?", ("#{material_type} => true"))
  #           scoped_materials.map {|material| product_groups << [media_group, material].flatten}
  #         end
  #       end
  #     end
  #   end
  #   product_groups
  # end
  #
  # def self.existing_products
  #   existing_set =[]
  #   Element.by_kind('product').each do |product|
  #     product_group = product.elements #where(kind: %w[medium material])
  #     existing_set << product_group if product_group.any?
  #   end
  #   existing_set
  # end
  #
  # def self.create_missing(existing_set)
  #   product_set.each do |target_set|
  #     if existing_set.exclude?(target_set)
  #       build_product(target_set)
  #     end
  #   end
  # end
  #
  # def self.create_all
  #   product_set.each do |target_set|
  #     build_product(target_set)
  #   end
  # end
  #
  # def self.build_product(target_set)
  #   name = format_product_name(target_set.map(&:name))
  #   product = find_or_create_by(kind: 'product', name: name)
  #   target_set.map {|target| assoc_unless_included(origin: product, target: target)}
  # end
  #
  # def self.format_product_name(name_set)
  #   if idx = name_set.index('sculpture')
  #     name_set[0..-2].insert(idx, name_set[-1]).join(' ')
  #   else
  #     name_set.insert(-2, 'on').join(' ')
  #   end
  # end
  #
  # def self.build_product_tag(name_set)
  #   h ={}
  #   name_set.each do |name|
  #     h["#{name}"] = 'true' if product_tags.include?(name)
  #   end
  #   h
  # end
  #
  # def self.product_tags
  #   Medium::BooleanTag.new.primary + %w[original one-of-a-kind production limited-edition hand-pulled]
  # end

  ################################################################ ElementKind.pop_elements

  def self.pop_elements
    set_text_tags(build_element)
  end

  def self.build_element
    text_tag_konstants =[]
    self.constants.each do |konstant| #Medium
      text_tag_konstants << konstant if scoped_constant(konstant).constants.include?(:TextTag)
      scoped_constant(konstant, :BooleanTag).instance_methods(false).each do |instance_method| #ElementKind::Medium::BooleanTag.instance_methods => primary...
        scoped_constant(konstant, :BooleanTag).new.public_send(instance_method).each do |value|
          element = find_or_create_by(kind: to_snake(konstant), name: value)
          update_tags(element, h ={instance_method.to_s => 'true'})
        end
      end
    end
    text_tag_konstants
  end

  def self.set_text_tags(text_tag_konstants)
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

  ################################################################ ElementKind.pop_elements

  module Medium
    class BooleanTag
      def primary
        %w[painting drawing mixed-media print sericel sculpture hand-blown hand-made]
      end

      def secondary
        %w[embellished hand-pulled]
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
