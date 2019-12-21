module MaterialType

  module Canvas
    extend Category
    # MaterialType::Canvas.option_sets
    # def self.option_sets
    #   [
    #     [StandardCanvas.name, [StandardCanvas, StandardCanvas.option_values]],
    #     [BoxedCanvas.name, [BoxedCanvas, BoxedCanvas.option_values]]
    #   ]
    # end

    class StandardCanvas
      extend Category

      def self.option_values
        ['canvas', 'canvas board', 'textured canvas']
      end

      def self.mounting
        Mounting::FlatMounting
      end
    end

  end

  module Paper

    class StandardPaper
      def self.option_values
        ['paper', 'deckle edge paper', 'rice paper', 'arches paper', 'sommerset paper', 'mother of pearl paper']
      end
    end

    class PhotographyPaper
      extend Category

      def self.option_values
        ['paper', 'photography paper', 'archival grade paper']
      end
    end

    class AnimationPaper
      extend Category

      def self.option_values
        ['paper', 'animation paper']
      end
    end

  end

  module Board

    class Wood
      extend Category

      def self.option_values
        ['wood', 'wood panel', 'board']
      end
    end

    class Acrylic
      extend Category

      def self.option_values
        ['acrylic', 'acrylic panel', 'resin']
      end
    end

  end

  module Metal
    extend Category

    class Metal
      def self.option_values
        ['metal', 'metal panel', 'aluminum', 'aluminum panel']
      end
    end

  end

  module Box
    extend Category

    class MetalBox
      def self.option_values
        ['metal box', 'aluminum box']
      end
    end

    class WoodBox
      def self.option_values
        ['wood box', 'resin laminated wood box']
      end
    end

  end

  module Sericel
    extend Category

    class Sericel
      def self.option_values
        ['sericel', 'sericel with background', 'sericel with lithographic background']
      end
    end

  end

  module Sculpture

    class Glass
      extend Category

      def self.option_values
        ['glass']
      end
    end

    class Ceramic
      extend Category

      def self.option_values
        ['ceramic']
      end
    end

    class Bronze
      extend Category

      def self.option_values
        ['bronze']
      end
    end

    class Synthetic
      extend Category

      def self.option_values
        ['acrylic', 'lucite', 'mixed media']
      end
    end

    class Stone
      extend Category

      def self.option_values
        ['pewter']
      end
    end

  end
end
