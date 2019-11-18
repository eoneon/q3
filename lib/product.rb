module Product
  extend BuildSet
  extend ProductBuild

  def self.populate
    derivative_hsh = derivative_elements
    self.constants.each do |mojule|                                                                                                        #Original, OneOfAKind, PrintMedium
      category = find_or_create_by(kind: 'category', name: format_attr(mojule,4)) #Element(kind: 'category', name: 'original'),...

      konstant = to_scoped_constant(self, mojule) #category_constant
      #constant_hsh = {category_scope: to_scoped_constant(self, mojule), medium_scope: to_scoped_constant(self, mojule, :medium), mounting_dimension_scope: to_scoped_constant(self, mojule, :mounting_dimension)}                                                                                         #Product::Original, Product::OneOfAKind, Product::PrintMedium
      to_scoped_constant(konstant, :medium).constants.each do |klass|
        #constant_hsh = {klass_scope: to_scoped_constant(constant_hsh[:medium_scope], klass)}                                                                    #Product::Original::Medium => [:Painting, :Drawing, :Production], Product::OneOfAKind::Medium => [:MixedMedium, :Etching, :HandPulled],...
        medium = find_or_create_by(kind: 'medium', name: format_attr(klass,4))                                                             #Element(kind: 'medium', name: 'painting'),...

        to_scoped_constant(konstant, :medium, klass).new.sub_medium.each do |sub_medium_name|                                              #Product::Original::Medium.new.sub_medium => ['painting', 'oil', 'acrylic', 'mixed media', 'watercolor', 'pastel', 'guache', 'sumi ink']
          sub_medium = find_or_create_by(kind: 'sub_medium', name: format_attr(sub_medium_name,4))
          material_set = to_scoped_constant(konstant, :medium, klass).new.material.detect {|set| set.first.include?(sub_medium_name)}      #Element(kind: 'sub_medium', name: 'oil'),...
          material_set.last.map {|material_name| find_or_create_by(kind: 'material', name: material_name)}.each do |material|

            if category.name == 'sculpture'
              to_scoped_constant(konstant, :medium, klass).new.sculpture_type.each do |sculpture_type_name|
                sculpture_type = find_or_create_by(kind: 'sculpture_type', name: format_attr(sculpture_type_name,4))

                product_set = [[:medium, medium], [:material, material], [:sculpture_type, sculpture_type], [:category, category]]
                build_product(product_set)
                derivative_products(to_scoped_constant(konstant, :medium, klass), derivative_hsh, product_set)
              end
            else
              product_set = [[:category, category], [:sub_medium, sub_medium], [:medium, medium], [:material, material]]
              build_product(product_set)
              derivative_products(to_scoped_constant(konstant, :medium, klass), derivative_hsh, product_set)
            end
          end

        end

      end
    end
  end

  def self.derivative_products(konstant, hsh, product_set)
    build_product(product_set.insert(0, [:embellished, hsh[:embellished]])) if konstant.instance_methods(false).include?(:embellished)
    build_product(product_set.insert(-2, [:single_edition, hsh[:single_edition]])) if konstant.instance_methods(false).include?(:single_edition) && !(konstant.to_s.split('::').include?('StandardPrint') && konstant.instance_methods(false).include?(:embellished))
  end

  def self.derivative_elements
    h={
      embellished: find_or_create_by(kind: 'embellishment', name: 'embellished'),
      single_edition: find_or_create_by(kind: 'edition', name: 'single edition')
    }
  end

  def self.scopes
    set =[]
    Product.constants.each do |mojule|
      to_scoped_constant(self, mojule, :medium).constants.each do |konstant|
        scope_name = [to_snake(mojule), to_snake(konstant)].join('_')
        set << [scope_name, format_attr(mojule), format_attr(konstant)]
      end
    end
    set
  end

  def self.search
    set =[]
    #konstants = self.constants + SculptureProduct.constants
    self.constants.each do |mojule|
      to_scoped_constant(self, mojule, :medium).constants.each do |konstant|
        scope_name = [to_snake(mojule), to_snake(konstant)].join('_')
        value_set = [format_attr(mojule, 3), format_attr(konstant, 4)]
        set << [search_text(value_set), scope_name]
      end
    end
    set.prepend(['all products', 'products'])
  end

  def self.search_text(value_set)
    value_set = value_set.reject {|i| i == 'print medium'}
    value_set.append('media') if value_set.include?('production')
    value_set.append('prints') if value_set.include?('hand pulled')
    value_set.prepend('glass') if value_set.include?('hand blown')
    value_set.prepend('ceramic') if value_set.include?('hand made')
    value_set = word_arr(value_set) - ['standard']
    value_set.join(' ').pluralize
  end

  def self.all_media
    Product.constants.map {|mojule| to_scoped_constant(self, mojule, :medium).constants.map {|klass| format_attr(klass,3)}}.flatten
  end

  def self.flat_media
    Product.constants.reject {|konstant| to_snake(konstant) == 'sculpture'}.map {|mojule| to_scoped_constant(self, mojule, :medium).constants.map {|klass| format_attr(klass,3)}}.flatten
  end

  def self.sculpture_media
    Product::Sculpture::Medium.constants.map {|klass| format_attr(klass,3)}.flatten
  end

  #=> ["painting", "drawing", "production", "mixed medium", "etching", "hand pulled", "basic print", "standard print", "hand pulled", "sericel", "photograph", "standard print", "hand pulled", "sericel", "photograph"]

  def self.sculpture_type
    ['sculpture', 'vase', 'flat vase', 'bowl', 'jar', 'pumpkin', 'heart']
  end

  ##############################################################################

  module Original

    module Medium

      class Painting
        def sub_medium
          ['painting', 'oil', 'acrylic', 'mixed media', 'watercolor', 'pastel', 'guache', 'sumi ink']
        end

        def material
          [
            [['watercolor', 'pastel', 'guache', 'sumi ink'], ['paper']],
            [['painting', 'oil', 'acrylic', 'mixed media'], Material.standard_flat]
          ]
        end
      end

      class Drawing
        def sub_medium
          ['drawing', 'pen and ink', 'pencil']
        end

        def material
          [
            [Drawing.new.sub_medium, ['paper']]
          ]
        end
      end

      class Production
        def sub_medium
          ['production drawing', 'production sericel', 'hand painted production sericel']
        end

        def material
          [
            [['production drawing'], ['animation paper']],
            [['production sericel'], ['sericel']],
            [['hand painted production sericel'], ['sericel']]
          ]
        end
      end

    end

    module MountingDimension
      def self.category
        'two-d'
      end
    end
  end

  module OneOfAKind
    module Medium

      class MixedMedium
        def sub_medium
          ['mixed media', 'acrylic mixed media', 'mixed media overpaint', 'monoprint']
        end

        def material
          [
            [MixedMedium.new.sub_medium, Material.standard_flat]
          ]
        end

        def embellished
          MixedMedium.new.sub_medium
        end

        def single_edition
          ['mixed media', 'monoprint']
        end
      end

      class Etching
        def sub_medium
          ['etching']
        end

        def material
          [
            [Etching.new.sub_medium, ['paper']]
          ]
        end

        def embellished
          Etching.new.sub_medium
        end

        def single_edition
          Etching.new.sub_medium
        end
      end

      class HandPulled
        def sub_medium
          ['silkscreen']
        end

        def material
          [
            [['silkscreen'], ['canvas']]
          ]
        end

        def embellished
          HandPulled.new.sub_medium
        end

        def single_edition
          HandPulled.new.sub_medium
        end
      end

    end
  end

  module PrintMedium
    module Medium

      class BasicPrint
        def sub_medium
          ['print', 'fine art print', 'vintage style print', 'poster', 'vintage poster']
        end

        def material
          [
            [['print', 'fine art print', 'vintage style print'], Material.standard_flat],
            [['poster', 'vintage poster'], ['paper']]
          ]
        end
      end

      class StandardPrint
        def sub_medium
          ['giclee', 'serigraph', 'etching', 'lithograph', 'mixed media']
        end

        def material
          [
            [['giclee', 'serigraph', 'mixed media'], Material.standard_flat],
            [['lithograph', 'etching'], ['paper']]
          ]
        end

        def embellished
          StandardPrint.new.sub_medium
        end
      end

      class HandPulled
        def sub_medium
          ['silkscreen', 'lithograph']
        end

        def material
          [
            [['silkscreen'], ['canvas']],
            [['lithograph'], ['paper']]
          ]
        end

        def embellished
          HandPulled.new.sub_medium
        end
      end

      class Sericel
        def sub_medium
          ['sericel']
        end

        def material
          [
            [['sericel'], ['sericel']]
          ]
        end
      end

      class Photograph
        def sub_medium
          ['photograph', 'archival photograph', 'single exposure photograph']
        end

        def material
          [
            [Photograph.new.sub_medium, ['photography paper']]
          ]
        end
      end

    end
  end

  module LimitedEdition

    module Medium

      class StandardPrint < Product::PrintMedium::Medium::StandardPrint
        def embellished
          StandardPrint.new.sub_medium
        end
      end

      class HandPulled < Product::PrintMedium::Medium::HandPulled
        def embellished
          HandPulled.new.sub_medium
        end

        def single_edition
          HandPulled.new.sub_medium
        end
      end

      class Sericel < Product::PrintMedium::Medium::Sericel
      end

      class Photograph < Product::PrintMedium::Medium::Photograph
      end
    end
  end

  module Sculpture

    module Medium

      class HandBlown
        def sub_medium
          ['hand blown']
        end

        def material
          [
            [HandBlown.new.sub_medium, ['glass']]
          ]
        end

        def sculpture_type
          Product.sculpture_type.append('luminaire')
        end
      end

      class HandMade
        def sub_medium
          ['hand made']
        end

        def material
          [
            [HandMade.new.sub_medium, ['ceramic']]
          ]
        end

        def sculpture_type
          Product.sculpture_type
        end
      end

      class Sculpture
        def sub_medium
          ['sculpture']
        end

        def material
          [
            [Sculpture.new.sub_medium, ['glass', 'ceramic', 'bronze', 'acrylic', 'pewter', 'lucite', 'mixed media']]
          ]
        end

        def sculpture_type
          ['sculpture']
        end
      end

      class LimitedEdition < Sculpture
      end
    end

  end
end
