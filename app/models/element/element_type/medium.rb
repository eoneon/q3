class Medium < ElementBuild

  def self.current_file
    File.basename(__FILE__, ".rb")
  end

  def self.current_dir
    File.expand_path(File.dirname(__FILE__)).split('/').last
  end

  def self.standard_flat_material
    [PaperMaterial::Paper, CanvasMaterial::Canvas, Board::Wood, Board::Acrylic, MetalMaterial::Metal, Box::MetalBox, Box::MetalBox]
  end

  def self.paper_material
    [PaperMaterial::Paper]
  end

  def self.canvas_material
    [CanvasMaterial::Canvas]
  end

  def self.sericel_material
    [SericelMaterial::Sericel]
  end

  def self.photo_material
    [PaperMaterial::PhotographyPaper]
  end

  def self.sculpture_material
    [SculptureMaterial::Glass, SculptureMaterial::Ceramic, SculptureMaterial::Bronze, SculptureMaterial::Synthetic, SculptureMaterial::Stone]
  end

  def self.glass_material
    [SculptureMaterial::Glass]
  end

  def self.ceramic_material
    [SculptureMaterial::Ceramic]
  end
  # def self.product_name
  #   ['on', element_name].join(' ')
  # end

  #Painting ##############################################################################
  # Painting::StandardPainting::OptionGroup.option
  class StandardPainting < Medium
    class OptionValue < StandardPainting
      def self.option
        ['painting', 'oil', 'acrylic', 'mixed media']
      end
    end

    class AssocValue < StandardPainting
      def self.option
        standard_flat_material
      end
    end
  end

  class PaintingOnPaper < Medium
    class OptionValue < PaintingOnPaper
      def self.option
        ['watercolor', 'pastel', 'guache', 'sumi ink']
      end
    end

    class AssocValue < PaintingOnPaper
      def self.option
        paper_material
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

    class AssocValue < StandardDrawing
      def self.option
        paper_material
      end
    end
  end

  class ProductionDrawing < Medium
    class OptionValue < ProductionDrawing
      def self.option
        ['production drawing']
      end
    end

    class AssocValue < ProductionDrawing
      def self.option
        paper_material
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

    class AssocValue < StandardMixedMedium
      def self.option
        standard_flat_material
      end
    end
  end

  class PeterMaxMixedMedium < Medium
    class OptionValue < StandardMixedMedium
      def self.option
        ['acrylic mixed media', 'mixed media overpaint']
      end
    end

    class AssocValue < StandardMixedMedium
      def self.option
        paper_material
      end
    end
  end

  class Etching < Medium
    class OptionValue < Etching
      def self.option
        ['etching', 'hand painted etching', 'hand tinted etching']
      end
    end

    class AssocValue < Etching
      def self.option
        paper_material
      end
    end
  end

  class HandPulled < Medium
    class OptionValue < HandPulled
      def self.option
        ['silkscreen']
      end
    end

    class AssocValue < HandPulled
      def self.option
        canvas_material
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

    class AssocValue < StandardPrint
      def self.option
        standard_flat_material
      end
    end
  end

  class StandardPrintOnPaper < Medium
    class OptionValue < StandardPrintOnPaper
      def self.option
        ['etching', 'lithograph']
      end
    end

    class AssocValue < StandardPrintOnPaper
      def self.option
        paper_material
      end
    end
  end

  class Sericel < Medium
    class OptionValue < Sericel
      def self.option
        ['sericel', 'hand painted sericel']
      end
    end

    class AssocValue < Sericel
      def self.option
        sericel_material
      end
    end
  end

  class Photograph < Medium
    class OptionValue < Photograph
      def self.option
        ['photograph', 'archival photograph', 'single exposure photograph']
      end
    end

    class AssocValue < Photograph
      def self.option
        photo_material
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

    class AssocValue < StandardBasicPrint
      def self.option
        standard_flat_material
      end
    end
  end

  class BasicPrintOnPaper < Medium
    class OptionValue < BasicPrintOnPaper
      def self.option
        ['poster', 'vintage poster']
      end
    end

    class AssocValue < BasicPrintOnPaper
      def self.option
        paper_material
      end
    end
  end

  #sculpture medium ############################################################

  class StandardSculpture < Medium
    class OptionValue < StandardSculpture
      def self.option
        ['sculpture']
      end
    end

    class AssocValue < StandardSculpture
      def self.option
        sculpture_material
      end
    end
  end

  class HandBlownGlass < Medium
    class OptionValue < HandBlownGlass
      def self.option
        ['hand blown glass sculpture']
      end
    end

    class AssocValue < HandBlownGlass
      def self.option
        glass_material
      end
    end
  end

  class HandMadeCeramic < Medium
    class OptionValue < HandMadeCeramic
      def self.option
        ['hand made ceramic sculpture']
      end
    end

    class AssocValue < HandMadeCeramic
      def self.option
        ceramic_material
      end
    end
  end
end
