module FlatProduct
  extend BuildSet
  extend ProductBuild

  def self.populate
    derivative_hsh = derivative_elements
    self.constants.each do |mojule|                                                                                                       #Original, OneOfAKind, PrintMedium
      category = find_or_create_by(kind: 'category', name: element_name(mojule))                                                          #Element(kind: 'category', name: 'original'),...
      konstant = to_scoped_constant(self, mojule)                                                                                         #FlatProduct::Original, FlatProduct::OneOfAKind, FlatProduct::PrintMedium
      to_scoped_constant(konstant, :medium).constants.each do |klass|                                                                     #FlatProduct::Original::Medium => [:Painting, :Drawing, :Production], FlatProduct::OneOfAKind::Medium => [:MixedMedium, :Etching, :HandPulled],...
        medium = find_or_create_by(kind: 'medium', name: element_name(klass))                                                             #Element(kind: 'medium', name: 'painting'),...
        to_scoped_constant(konstant, :medium, klass).new.sub_medium.each do |sub_medium_name|                                             #FlatProduct::Original::Medium.new.sub_medium => ['painting', 'oil', 'acrylic', 'mixed media', 'watercolor', 'pastel', 'guache', 'sumi ink']
          sub_medium = find_or_create_by(kind: 'sub_medium', name: element_name(sub_medium_name))
          material_set = to_scoped_constant(konstant, :medium, klass).new.material.detect {|set| set.first.include?(sub_medium_name)}     #Element(kind: 'sub_medium', name: 'oil'),...
          material_set.last.map {|material_name| find_or_create_by(kind: 'material', name: material_name)}.each do |material|
            product_set = [[:category, category], [:sub_medium, sub_medium], [:medium, medium], [:material, material]]
            build_product(product_set)
            derivative_products(to_scoped_constant(konstant, :medium, klass), derivative_hsh, product_set)
          end
        end
      end
    end
  end

  def self.derivative_products(konstant, hsh, product_set)
    build_product(product_set.insert(0,[:embellished, hsh[:embellished]]).insert(1, [:limited_edition, hsh[:limited_edition]])) if include_all?([:embellished, :limited_edition], konstant.instance_methods(false))
    build_product(product_set.insert(0, [:limited_edition, hsh[:limited_edition]])) if konstant.instance_methods(false).include?(:limited_edition)
    build_product(product_set.insert(0, [:embellished, hsh[:embellished]])) if konstant.instance_methods(false).include?(:embellished)
    build_product(product_set.insert(-2, [:embellished, hsh[:embellished]])) if konstant.instance_methods(false).include?(:single_edition) && !(konstant.to_s.split('::').include?('StandardPrint') && konstant.instance_methods(false).include?(:embellished))
  end

  def self.derivative_elements
    h={
      embellished: find_or_create_by(kind: 'embellishment', name: 'embellished'),
      single_edition: find_or_create_by(kind: 'edition', name: 'single edition'),
      limited_edition: find_or_create_by(kind: 'edition', name: 'limited edition')
    }
  end

  def self.product_search
    set =[]
    FlatProduct.constants.each do |mojule|
      to_scoped_constant(self, mojule, :medium).constants.each do |konstant|
        set << [format_attr(mojule, 3), format_attr(konstant)]
      end
    end
    set
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
            [['production sericel'], ['sericel', 'sericel with background', 'sericel with lithographic background']],
            [['hand painted production sericel'], ['sericel', 'sericel with background', 'sericel with lithographic background']]
          ]
        end
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
          ['giclee', 'serigraph', 'etching', 'lithograph', 'mixed media (print)']
        end

        def material
          [
            [['giclee', 'serigraph', 'mixed media (print)'], Material.standard_flat],
            [['lithograph', 'etching'], ['paper']]
          ]
        end

        def embellished
          StandardPrint.new.sub_medium
        end

        def limited_edition
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

        def limited_edition
          HandPulled.new.sub_medium
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
            [['sericel'], Material.sericel_material]
          ]
        end

        def limited_edition
          Sericel.new.sub_medium
        end
      end

      class Photograph
        def sub_medium
          ['photograph']
        end

        def material
          [
            [['photograph'], ['photography paper']]
          ]
        end

        def limited_edition
          Photograph.new.sub_medium
        end
      end

    end
  end
end
