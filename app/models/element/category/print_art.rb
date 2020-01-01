class PrintArt < ElementBuild
  #PrintArt::OpenPrint::AssocGroup.option
  def self.current_file
    File.basename(__FILE__, ".rb")
  end

  def self.current_dir
    File.expand_path(File.dirname(__FILE__)).split('/').last
  end

  def self.open_print_classes
    [PrintMedium, BasicPrint].map {|origin_class| filtered_classes(origin_class, :AssocGroup)}.flatten
  end

  ##############################################################################

  class LimitedPrint < PrintArt

    class AssocGroup < LimitedPrint
      def self.option
        [[assoc_key_attrs(:medium), filtered_classes(LimitedEditionPrint, :AssocGroup)]]
      end
    end
  end

  class SinglePrint < PrintArt

    class AssocGroup < SinglePrint
      def self.option
        [[assoc_key_attrs(:medium), [SingleEdition::NumberedOneOfOne]]]
      end
    end
  end

  class OpenPrint < PrintArt

    class AssocGroup < OpenPrint
      def self.option
        [[assoc_key_attrs(:medium), open_print_classes]]
      end
    end
  end

end
