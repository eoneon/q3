class PrintMedium < Medium

  def self.current_file
    File.basename(__FILE__, ".rb")
  end

  def self.current_dir
    File.expand_path(File.dirname(__FILE__)).split('/').last
  end

  def self.option_values
    scope_context(current_dir, origin, 'option_value').option
  end

  ##############################################################################

  class StandardPrint < PrintMedium

    class OptionGroup < StandardPrint
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < StandardPrint
      def self.option
        [[assoc_key_attrs(:material), [PaperMaterial::Paper, CanvasMaterial::Canvas, Board::Wood, Board::Acrylic, MetalMaterial::Metal, Box::MetalBox, WoodBox::MetalBox]]]
      end
    end

  end

  class StandardPrintOnPaper < PrintMedium

    class OptionGroup < StandardPrintOnPaper
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < StandardPrintOnPaper
      def self.option
        [[assoc_key_attrs(:material), [PaperMaterial::Paper]]]
      end
    end

  end

  class Sericel < PrintMedium

    class OptionGroup < Sericel
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < Sericel
      def self.option
        [[assoc_key_attrs(:material), [SericelMaterial::Sericel]]]
      end
    end

  end

  class Photograph < PrintMedium

    class OptionGroup < Photograph
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < Photograph
      def self.option
        [[assoc_key_attrs(:material), [Paper::PhotographyPaper]]]
      end
    end

  end

end
