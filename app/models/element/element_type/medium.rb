class Medium < ElementBuild

  def self.current_file
    File.basename(__FILE__, ".rb")
  end

  def self.current_dir
    File.expand_path(File.dirname(__FILE__)).split('/').last
  end

  # def self.product_name
  #   ['on', element_name].join(' ')
  # end

  #Painting ##############################################################################

  class StandardPainting < Medium
    class OptionValue < StandardPainting
      def self.option
        ['painting', 'oil', 'acrylic', 'mixed media']
      end
    end
  end

  class PaintingOnPaper < Medium
    class OptionValue < PaintingOnPaper
      def self.option
        ['watercolor', 'pastel', 'guache', 'sumi ink']
      end
    end
  end

  #Drawing ##############################################################################

  class StandardDrawing < Medium
    class OptionValue < StandardDrawing
      def self.option
        ['drawing', 'pen and ink', 'pencil']
      end
    end
  end

  class ProductionDrawing < Medium
    class OptionValue < ProductionDrawing
      def self.option
        ['production drawing']
      end
    end
  end

  #MixedMedium ##############################################################################

  class StandardMixedMedium < Medium
    class OptionValue < StandardMixedMedium
      def self.option
        ['mixed media', 'acrylic mixed media', 'mixed media overpaint', 'monoprint']
      end
    end
  end

  class PeterMaxMixedMedium < Medium
    class OptionValue < StandardMixedMedium
      def self.option
        ['acrylic mixed media', 'mixed media overpaint']
      end
    end
  end

  class Etching < Medium
    class OptionValue < Etching
      def self.option
        ['etching', 'hand painted etching', 'hand tinted etching']
      end
    end
  end

  class HandPulled < Medium
    class OptionValue < HandPulled
      def self.option
        ['silkscreen']
      end
    end
  end

  #standard print medium ##############################################################################

  class StandardPrint < Medium
    class OptionValue < StandardPrint
      def self.option
        ['giclee', 'serigraph', 'silkscreen', 'hand pulled silkscreen', 'mixed media']
      end
    end
  end

  class StandardPrintOnPaper < Medium
    class OptionValue < StandardPrintOnPaper
      def self.option
        ['etching', 'lithograph']
      end
    end
  end

  class Sericel < Medium
    class OptionValue < Sericel
      def self.option
        ['sericel', 'hand painted sericel']
      end
    end
  end

  class Photograph < Medium
    class OptionValue < Photograph
      def self.option
        ['photograph', 'archival photograph', 'single exposure photograph']
      end
    end
  end

  #basic print medium ##############################################################################

  class StandardBasicPrint < Medium
    class OptionValue < StandardBasicPrint
      def self.option
        ['print', 'fine art print', 'vintage style print']
      end
    end
  end

  class BasicPrintOnPaper < Medium
    class OptionValue < BasicPrintOnPaper
      def self.option
        ['poster', 'vintage poster']
      end
    end
  end

  #sculpture medium ############################################################

  class StandardSculptureMedium < Medium
    class OptionValue < StandardSculptureMedium
      def self.option
        ['sculpture']
      end
    end
  end

  class HandBlownGlass < Medium
    class OptionValue < HandBlownGlass
      def self.option
        ['hand blown glass sculpture']
      end
    end
  end

  class HandMadeCeramic < Medium
    class OptionValue < HandMadeCeramic
      def self.option
        ['hand made ceramic sculpture']
      end
    end
  end
end
