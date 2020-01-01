class BasicPrint < Medium

  def self.current_file
    File.basename(__FILE__, ".rb")
  end

  def self.current_dir
    File.expand_path(File.dirname(__FILE__)).split('/').last
  end

  # def self.option_values
  #   scope_context(current_dir, origin, 'option_value').option
  # end
  # Painting::StandardPainting::OptionGroup.option[0][1] .option_value_attrs('oil')
  ##############################################################################

  class StandardBasicPrint < BasicPrint

    class OptionGroup < StandardBasicPrint
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < StandardBasicPrint
      def self.option
        [[assoc_key_attrs(:material), assoc_values]]
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
        [[assoc_key_attrs(:material), assoc_values]]
      end
    end
  end

end
