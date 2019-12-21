class OriginalArt < ElementBuild
  #OriginalArt::Original::AssocGroup.option
  def self.current_file
    File.basename(__FILE__, ".rb")
  end

  def self.current_dir
    File.expand_path(File.dirname(__FILE__)).split('/').last
  end

  ##############################################################################

  class Original < OriginalArt

    class AssocGroup < Original
      def self.option
        [[assoc_key_attrs(:medium), [Painting::StandardPainting, Painting::PaintingOnPaper, Drawing::StandardDrawing, Drawing::AzoulayDrawing, Drawing::ProductionDrawing]]]
      end
    end
  end

  class OneOfAKind < OriginalArt

    class AssocGroup < OneOfAKind
      def self.option
        [[assoc_key_attrs(:medium), [MixedMedium::StandardMixedMedium, MixedMedium::PeterMaxMixedMedium, MixedMedium::Etching, MixedMedium::HandPulled]]]
      end
    end
  end

end
