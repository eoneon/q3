module SculptureProduct
  extend BuildSet
  extend ProductBuild

  def self.populate
    self.constants.each do |mojule|
      category = find_or_create_by(kind: 'category', name: format_attr(mojule,4))             #sculpture
      konstant = to_scoped_constant(self, mojule)
      to_scoped_constant(konstant, :medium).constants.each do |klass|
        medium = find_or_create_by(kind: 'medium', name: format_attr(klass,4))                #hand blown, hand made, sculpture

        to_scoped_constant(konstant, :medium, klass).new.sub_medium.each do |sub_medium_name|
          sub_medium = find_or_create_by(kind: 'sub_medium', name: format_attr(sub_medium_name,4))
          material_set = to_scoped_constant(konstant, :medium, klass).new.material.detect {|set| set.first.include?(sub_medium_name)}
          material_set.last.map {|material_name| find_or_create_by(kind: 'material', name: material_name)}.each do |material|

            to_scoped_constant(konstant, :medium, klass).new.sculpture_type.each do |sculpture_type_name|
              sculpture_type = find_or_create_by(kind: 'sculpture_type', name: format_attr(sculpture_type_name,4))
              product_set = [[:medium, medium], [:material, material], [:sculpture_type, sculpture_type], [:category, category]]
              build_product(product_set)
            end
            
          end
        end
      end
    end
  end

  def self.sculpture_type
    ['sculpture', 'vase', 'flat vase', 'bowl', 'jar', 'pumpkin', 'heart']
  end

  # def self.scopes
  #   set =[]
  #   self.constants.each do |mojule|
  #     to_scoped_constant(self, mojule, :medium).constants.each do |konstant|
  #       scope_name = [to_snake(mojule), to_snake(konstant)].join('_')
  #       set << [scope_name, format_attr(mojule), format_attr(konstant)]
  #     end
  #   end
  #   set
  # end

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

      class LimitedEdition < Sculpture
      end
    end

  end
end
