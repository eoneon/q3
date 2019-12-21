class BasicPrint < Medium

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

  class StandardBasicPrint < BasicPrint

    class OptionGroup < StandardBasicPrint
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < StandardBasicPrint
      def self.option
        [[assoc_key_attrs(:material), [PaperMaterial::Paper, CanvasMaterial::Canvas, Board::Wood, Board::Acrylic, MetalMaterial::Metal, Box::MetalBox, WoodBox::MetalBox]]]
      end
    end
  end

  class BasicPrintOnPaper < BasicPrint

    class OptionGroup < BasicPrintOnPaper
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < BasicPrintOnPaper
      def self.option
        [[assoc_key_attrs(:material), [PaperMaterial::Paper]]]
      end
    end
  end

end
