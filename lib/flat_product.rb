module FlatProduct
  extend BuildSet
  extend ProductBuild

  def self.populate
    self.constants.each do |mojule|
      category = find_or_create_by(kind: 'category', name: element_name(mojule))
      konstant = to_scoped_constant(self, mojule)
      to_scoped_constant(konstant, :medium).constants.each do |klass|
        medium = find_or_create_by(kind: 'medium', name: element_name(klass))

        to_scoped_constant(konstant, :medium, klass).new.sub_medium.each do |sub_medium_name|
          sub_medium = find_or_create_by(kind: 'sub_medium', name: element_name(sub_medium_name))
          if material_set = to_scoped_constant(konstant, :medium, klass).new.material.detect {|set| set.first.include?(sub_medium_name)}
            material_set.last.map {|material_name| find_or_create_by(kind: 'material', name: material_name)}.each do |material|
              build_product([category, sub_medium, medium, material])
            end
          else
            build_product([category, sub_medium, medium])
          end
        end
      end
    end
  end

  ##############################################################################

  # def self.on_material
  #   standard_flat | photography_paper | production_drawing_paper
  # end
  #
  # def self.standard_flat
  #   %w[canvas paper board metal]
  # end
  #
  # def self.photography_paper
  #   ['photography paper']
  # end
  #
  # def self.production_drawing_paper
  #   ['animation paper']
  # end

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
            [['painting', 'oil', 'acrylic', 'mixed media'], FlatProduct.standard_flat]
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
          ['production drawing', 'production sericel']
        end

        def material
          [
            [['production drawing'], ['animation paper']],
            [['production sericel'], ['sericel', 'sericel with background', 'sericel with lithographic background']]
          ]
        end
      end

    end
  end

  module OneOfAKind
    module Medium

      class MixedMedium
        def sub_medium
          ['mixed media', 'acrylic mixed media', 'mixed media overpaint']
        end

        def material
          [
            [MixedMedium.new.sub_medium, FlatProduct.standard_flat]
          ]
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
            [['print', 'fine art print', 'vintage style print'], FlatProduct.standard_flat],
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
            [['giclee', 'serigraph', 'mixed media (print)'], FlatProduct.standard_flat],
            [['lithograph', 'etching'], ['paper']]
          ]
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
      end

      class Sericel
        def sub_medium
          ['sericel']
        end

        def material
          [
            [['sericel'], ['sericel', 'sericel with background', 'sericel with lithographic background']]
          ]
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
      end

    end
  end
end
