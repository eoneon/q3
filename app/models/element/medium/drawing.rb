class Drawing < Medium

  def self.current_file
    File.basename(__FILE__, ".rb")
  end

  def self.current_dir
    File.expand_path(File.dirname(__FILE__)).split('/').last
  end

  # def self.option_values
  #   scope_context(current_dir, origin, 'option_value').option
  # end

  def self.assoc_origin
    OriginalArt::Original
  end

  ##############################################################################

  class StandardDrawing < Drawing

    class OptionGroup < StandardDrawing
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < StandardDrawing
      def self.option
        [[assoc_key_attrs(:material), assoc_values]]
      end
    end
  end

  class AzoulayDrawing < Drawing

    class OptionGroup < StandardDrawing
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < StandardDrawing
      def self.option
        [[assoc_key_attrs(:material), assoc_values]]
      end
    end
  end

  class ProductionDrawing < Drawing
    class OptionGroup < ProductionDrawing
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < ProductionDrawing
      def self.option
        [[assoc_key_attrs(:material), assoc_values]]
      end
    end
  end

end
