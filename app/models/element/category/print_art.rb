class PrintArt < ElementBuild
  #PrintArt::OpenPrint::AssocGroup.option
  # ElementBuild.filter_const_hash(Medium::LimitedEditionPrint, :AssocGroup)[:assoc_group][:pos_one_set]
  def self.current_file
    File.basename(__FILE__, ".rb")
  end

  def self.current_dir
    File.expand_path(File.dirname(__FILE__)).split('/').last
  end

  # def self.open_print_classes
  #   [PrintMedium, BasicPrint].map {|origin_class| filter_const_hash(origin_class, :AssocGroup)[:assoc_group][:pos_two_set]}
  # end

  ##############################################################################

  class LimitedPrint < PrintArt

    class AssocGroup < LimitedPrint
      def self.option
        [[assoc_key_attrs(:medium), [LimitedEditionPrint::LtdStandardPrint, LimitedEditionPrint::LtdPrintOnPaper, LimitedEditionPrint::LtdSericel, LimitedEditionPrint::LtdPhotograph]]]
      end
    end
  end

  class SinglePrint < PrintArt

    class AssocGroup < SinglePrint
      def self.option
        [[assoc_key_attrs(:medium), [MixedMedium::StandardMixedMedium, MixedMedium::Etching, MixedMedium::HandPulled]]]
      end
    end
  end

  class OpenPrint < PrintArt

    class AssocGroup < OpenPrint
      def self.option
        [[assoc_key_attrs(:medium), [PrintMedium::StandardPrint, PrintMedium::StandardPrintOnPaper, PrintMedium::Sericel, PrintMedium::Photograph, BasicPrint::StandardBasicPrint, BasicPrint::BasicPrintOnPaper]]]
      end
    end
  end

end
