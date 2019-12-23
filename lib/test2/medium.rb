module Medium
  extend Material

  def self.option_group
    self.constants.map {|konstant| konstant}
  end

  ##############################################################################

  class Painting < Category::Original

    def self.options
      standard_material_options | standard_paper_options
    end

    def self.material
      [
        [standard_material_options, Material::PaintingMaterial.options],
        [standard_paper_options, [Material::StandardPaper.name]]
      ]
    end

    def self.standard_paper_options
      ['watercolor', 'pastel', 'guache', 'sumi ink']
    end

    def self.standard_material_options
      ['painting', 'oil', 'acrylic', 'mixed media']
    end

  end

  ##############################################################################

  class Drawing < Category::Original

    def self.options
      ['drawing', 'pen and ink', 'pencil']
    end

    def self.material
      [
        [Drawing.options, [Material::StandardPaper.name]]
      ]
    end
  end

  ##############################################################################

  class AzoulayDrawing < Drawing
    def self.category
      Drawing.category
    end

    def self.name
      name_split = decamelize(self.to_s.split('::').last,3).split(' ')
      [name_split[0].capitalize, name_split[1]].join(' ')
    end

    def self.option_groups
      ['single edition', 'embellished', 'leafing']
    end
  end

  ##############################################################################

  class ProductionDrawing < Category::Original

    def self.options
      ['production drawing']
    end

    def self.material
      [
        [ProductionDrawing.options, [Material::AnimationPaper.name]]
      ]
    end
  end

  ##############################################################################

  class ProductionSericel < Category::Original

    def self.options
      ['production sericel', 'hand painted production sericel']
    end

    def self.material
      [
        [ProductionSericel.options, [Material::Sericel.name]]
      ]
    end

    def self.name_order
      [:category, :option, :material]
    end
  end

  ##############################################################################

  class MixedMedium < Category::OneOfAKind

    def self.options
      ['mixed media', 'acrylic mixed media', 'mixed media overpaint', 'monoprint']
    end

    def self.material
      [
        [MixedMedium.options, Material::PaintingMaterial.options]
      ]
    end

    def self.option_groups
      ['single edition', 'embellished']
    end
  end

  ##############################################################################

  class PeterMaxMixedMedium < Category::OneOfAKind

    def self.options
      ['acrylic mixed media', 'mixed media overpaint']
    end

    def self.material
      [
        [PeterMaxMixedMedium.options, [Material::StandardPaper.name]]
      ]
    end

    def self.name
      name_split = decamelize(self.to_s.split('::').last,5).split(' ')
      [name_split[0].capitalize, name_split[1].capitalize, name_split[2..3]].flatten.join(' ')
    end

    def self.search_text
      [category, name.split('-').join(' ')].join(' ').pluralize
    end

  end

  ##############################################################################

  class Etching < Category::OneOfAKind

    def self.options
      ['etching']
    end

    def self.material
      [
        [Etching.options, [Material::StandardPaper.name]]
      ]
    end

    def self.option_groups
      ['single edition', 'embellished', 'leafing']
    end

  end

  ##############################################################################

  class HandPulled < Category::OneOfAKind

    def self.options
      ['silkscreen']
    end

    def self.material
      [
        [['silkscreen'], [Material::Canvas.name]]
      ]
    end

    def self.option_groups
      ['single edition', 'embellished']
    end

    def self.name_order
      [:category, :medium, :option, :material]
    end

    def self.search_text
      [category, name, 'prints'].join(' ')
    end
  end

  ##############################################################################

  class BasicPrint < Category::PrintMedium

    def self.options
      ['print', 'fine art print', 'vintage style print', 'poster', 'vintage poster']
    end

    def self.material
      [
        [['print', 'fine art print', 'vintage style print'], Material::PaintingMaterial.options],
        [['poster', 'vintage poster'], [Material::StandardPaper.name]]
      ]
    end

    def self.option_groups
      ['embellished']
    end
  end

  ##############################################################################

  class StandardPrint < Category::PrintMedium

    def self.options
      ['giclee', 'serigraph', 'etching', 'lithograph', 'mixed media']
    end

    def self.material
      [
        [['giclee', 'serigraph', 'mixed media'], Material::PaintingMaterial.options],
        [['lithograph', 'etching'], [Material::StandardPaper.name]]
      ]
    end

    def self.option_groups
      ['limited edition', 'single edition', 'embellished', 'leafing', 'remarque']
    end
  end

  ##############################################################################

  class HandPulledPrint < Category::PrintMedium

    def self.options
      ['silkscreen', 'lithograph']
    end

    def self.material
      [
        [['silkscreen'], [Material::Canvas.name]],
        [['lithograph'], [Material::StandardPaper.name]]
      ]
    end

    def self.option_groups
      ['limited edition', 'single edition', 'embellished']
    end

    def self.name_order
      [:medium, :option, :material]
    end

    def self.search_text
      name.split('-').join(' ').pluralize
    end
  end

  ##############################################################################

  class Sericel < Category::PrintMedium

    def self.options
      ['sericel']
    end

    def self.material
      [
        [['sericel'], [Material::Sericel.name]]
      ]
    end

    def self.option_groups
      ['limited edition']
    end

    def self.name_order
      [:option]
    end

  end

  ##############################################################################

  class Photograph < Category::PrintMedium

    def self.options
      ['photograph', 'archival photograph', 'single exposure photograph']
    end

    def self.material
      [
        [Photograph.options, [Material::PhotographyPaper.name]]
      ]
    end

    def self.option_groups
      ['limited edition']
    end
  end

  ##############################################################################

  class HandBlownGlass < Category::Sculpture

    def self.options
      ['sculpture']
    end

    def self.material
      [
        [HandBlownGlass.options, [Material::Glass.name]]
      ]
    end

    def self.name_order
      [:medium, :material, :option]
    end

  end

  ##############################################################################

  class HandMadeCeramic < Category::Sculpture

    def self.options
      ['sculpture']
    end

    def self.material
      [
        [HandMadeCeramic.options, [Material::Ceramic.name]]
      ]
    end

    def self.name_order
      [:medium, :material, :option]
    end

  end

  ##############################################################################

  class StandardSculpture < Category::Sculpture

    def self.options
      ['sculpture']
    end

    def self.material
      [
        [StandardSculpture.options, Material::SculptureMaterial.options]
      ]
    end

    def self.option_groups
      ['limited edition', 'embellished']
    end

    def self.name_order
      [:material, :category]
    end

    def self.search_text
      name.pluralize
    end
  end
end
