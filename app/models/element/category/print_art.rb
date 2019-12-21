class PrintArt < ElementBuild

  def self.current_file
    File.basename(__FILE__, ".rb")
  end

  def self.current_dir
    File.expand_path(File.dirname(__FILE__)).split('/').last
  end

  ##############################################################################

  class OpenPrint < PrintArt

    class AssocGroup < OpenPrint
      def self.option
        #[[assoc_key_attrs(:medium), [PrintMedium::StandardPrint, Painting::StandardPrintOnPaper, Drawing::StandardDrawing, Drawing::AzoulayDrawing, Drawing::ProductionDrawing]]]
      end
    end
  end

  class LimitedPrint < PrintArt

    class AssocGroup < LimitedPrint
      def self.option
        #[[assoc_key_attrs(:medium), [Painting::StandardPainting, Painting::PaintingOnPaper, Drawing::StandardDrawing, Drawing::AzoulayDrawing, Drawing::ProductionDrawing]]]
      end
    end
  end

  class SinglePrint < PrintArt

    class AssocGroup < SinglePrint
      def self.option
        #[[assoc_key_attrs(:medium), [Painting::StandardPainting, Painting::PaintingOnPaper, Drawing::StandardDrawing, Drawing::AzoulayDrawing, Drawing::ProductionDrawing]]]
      end
    end
  end
end
