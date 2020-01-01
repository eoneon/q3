class Material < ElementBuild
  # Material::Paper::OptionValue
  def self.current_file
    File.basename(__FILE__, ".rb")
  end

  def self.current_dir
    File.expand_path(File.dirname(__FILE__)).split('/').last
  end

  def self.product_name
    ['on', element_name].join(' ')
  end

  ##############################################################################


  #paper ##############################################################################

  class Paper < Material
    class OptionValue < Paper
      def self.option
        ['paper', 'deckle edge paper', 'rice paper', 'arches paper', 'sommerset paper', 'mother of pearl paper']
      end
    end
  end

  class PhotographyPaper < Material
    class OptionValue < PhotographyPaper
      def self.option
        ['paper', 'photography paper', 'archival grade paper']
      end
    end
  end

  class AnimationPaper < Material
    class OptionValue < AnimationPaper
      def self.option
        ['paper', 'animation paper']
      end
    end
  end

  #canvas ##############################################################################

  class Canvas < Material
    class OptionValue < Canvas
      def self.option
        ['canvas', 'canvas board', 'textured canvas']
      end
    end
  end

  #board ##############################################################################

  class Wood < Material
    class OptionValue < Wood
      def self.option
        ['wood', 'wood panel', 'board']
      end
    end
  end

  class Acrylic < Material
    class OptionValue < Acrylic
      def self.option
        ['acrylic', 'acrylic panel', 'resin']
      end
    end
  end

  #metal ##############################################################################

  class Metal < Material
    class OptionValue < Metal
      def self.option
        ['metal', 'metal panel', 'aluminum', 'aluminum panel']
      end
    end
  end

  #box ##############################################################################

  class MetalBox < Material
    class OptionValue < MetalBox
      def self.option
        ['metal box', 'aluminum box']
      end
    end
  end

  class WoodBox < Material
    class OptionValue < WoodBox
      def self.option
        ['wood box', 'resin laminated wood box']
      end
    end
  end

  #sericel ##############################################################################

  class Sericel < Material
    class OptionValue < Sericel
      def self.option
        ['sericel', 'sericel with background', 'sericel with lithographic background']
      end
    end
  end

  #sculpture ##############################################################################

  class Glass < Material
    class OptionValue < Glass
      def self.option
        ['glass']
      end
    end
  end

  class Ceramic < Material
    class OptionValue < Ceramic
      def self.option
        ['ceramic']
      end
    end
  end

  class Bronze < Material
    class OptionValue < Bronze
      def self.option
        ['bronze']
      end
    end
  end

  class Synthetic < Material
    class OptionValue < Synthetic
      def self.option
        ['acrylic', 'lucite', 'mixed media']
      end
    end
  end

  class Stone < Material
    class OptionValue < Stone
      def self.option
        ['pewter']
      end
    end
  end

end
