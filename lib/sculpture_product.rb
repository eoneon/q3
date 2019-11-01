module SculptureProduct
  extend BuildSet
  extend ProductBuild

  def self.populate
    self.constants.each do |mojule|
      category = find_or_create_by(kind: 'category', name: element_name(mojule))             #sculpture
      konstant = to_scoped_constant(self, mojule)
      to_scoped_constant(konstant, :medium).constants.each do |klass|
        medium = find_or_create_by(kind: 'medium', name: element_name(klass))                #hand blown, hand made, sculpture

        to_scoped_constant(konstant, :medium, klass).new.sub_medium.each do |sub_medium_name|
          sub_medium = find_or_create_by(kind: 'sub_medium', name: element_name(sub_medium_name))
          material_set = to_scoped_constant(konstant, :medium, klass).new.material.detect {|set| set.first.include?(sub_medium_name)}
          material_set.last.map {|material_name| find_or_create_by(kind: 'material', name: material_name)}.each do |material|
            to_scoped_constant(konstant, :medium, klass).new.sculpture_type.each do |sculpture_type_name|
              sculpture_type = find_or_create_by(kind: 'sculpture_type', name: element_name(sculpture_type_name))
              build_product([medium, material, sculpture_type, category])
            end
          end
        end
      end
    end
  end

  def self.sculpture_type
    ['sculpture', 'vase', 'flat vase', 'bowl', 'jar', 'pumpkin', 'heart']
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
          SculptureProduct.sculpture_type.append('luminaire')
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
          SculptureProduct.sculpture_type
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
    end

  end
end
