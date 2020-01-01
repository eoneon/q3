class LimitedEditionPrint < Medium

  def self.current_file
    File.basename(__FILE__, ".rb")
  end

  def self.current_dir
    File.expand_path(File.dirname(__FILE__)).split('/').last
  end

  # def self.option_values
  #   scope_context(current_dir, origin, 'option_value').option
  # end

  ##############################################################################

  class LtdStandardPrint < LimitedEditionPrint

    class OptionGroup < LtdStandardPrint
      def self.option
        [[element_attrs, Medium::StandardPrint::OptionValue]]
      end
    end

    class AssocGroup < LtdStandardPrint
      def self.option
        [[assoc_key_attrs(:material), [PaperMaterial::Paper, CanvasMaterial::Canvas, Board::Wood, Board::Acrylic, MetalMaterial::Metal, Box::MetalBox, Box::WoodBox]]]
      end
    end
  end

  class LtdPrintOnPaper < LimitedEditionPrint

    class OptionGroup < LtdPrintOnPaper
      def self.option
        [[element_attrs, Medium::StandardPrintOnPaper::OptionValue]]
      end
    end

    class AssocGroup < LtdPrintOnPaper
      def self.option
        [[assoc_key_attrs(:material), [PaperMaterial::Paper]]]
      end
    end
  end

  class LtdSericel < LimitedEditionPrint

    class OptionGroup < LtdSericel
      def self.option
        [[element_attrs, Medium::Sericel::OptionValue]]
      end
    end

    class AssocGroup < LtdSericel
      def self.option
        [[assoc_key_attrs(:material), [SericelMaterial::Sericel]]]
      end
    end
  end

  class LtdPhotograph < LimitedEditionPrint

    class OptionGroup < LtdPhotograph
      def self.option
        [[element_attrs, Medium::Photograph::OptionValue]]
      end
    end

    class AssocGroup < LtdPhotograph
      def self.option
        [[assoc_key_attrs(:material), [PaperMaterial::Photograph]]]
      end
    end
  end

end
