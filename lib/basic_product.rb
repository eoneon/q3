module BasicProduct
  extend BuildSet

  def self.populate
    self.constants.each do |mojule|
      category = find_or_create_by(kind: 'category', name: format_name(mojule))
      konstant = to_scoped_constant(self, mojule)
      to_scoped_constant(konstant, :medium).constants.each do |klass|
        medium = find_or_create_by(kind: 'medium', name: format_name(klass))

        to_scoped_constant(konstant, :medium, klass).new.sub_medium.each do |sub_medium_name|
          sub_medium = find_or_create_by(kind: 'sub_medium', name: format_name(sub_medium_name))
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

  def self.build_product(product_set)
    name_set = product_set.map(&:name)
    product = find_or_create_by(kind: 'product', name: product_name(name_set))
    update_tags(product, set_tags(name_set))
    product_set.map {|target| assoc_unless_included(origin: product, target: target)}
  end

  def self.set_tags(name_set, tags={})
    name_set.map {|name| tags.merge!(h={name => 'true'})}
    tags
  end

  def self.format_name(name)
    name_set = name.to_s.underscore.split('_')
    name_set.count >= 4 ? name_set.join('-') : name_set.join(' ')
  end

  def self.product_name(name_set, set=[])
    name_set = format_hand_pulled(name_set)
    name_set = name_set - ['print medium', 'basic print', 'standard print', 'mixed medium']
    name_set.insert(-2, 'on') if on_material.include?(name_set.last)

    name_set.join(' ').split(' ').each do |name|
      set << name if set.exclude?(name)
    end
    set.join(' ')
  end

  def self.format_hand_pulled(name_set)
    if name =  name_set.delete('hand pulled')
      name_set.prepend(name)
    else
      name_set
    end
  end

  ##############################################################################

  def self.on_material
    standard_flat | photography_paper | production_drawing_paper
  end

  def self.standard_flat
    %w[canvas paper board metal]
  end

  def self.photography_paper
    ['photography paper']
  end

  def self.production_drawing_paper
    ['animation paper']
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
            [['painting', 'oil', 'acrylic', 'mixed media'], BasicProduct.standard_flat]
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
            [MixedMedium.new.sub_medium, BasicProduct.standard_flat]
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
            [['print', 'fine art print', 'vintage style print'], BasicProduct.standard_flat],
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
            [['giclee', 'serigraph', 'mixed media (print)'], BasicProduct.standard_flat],
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
