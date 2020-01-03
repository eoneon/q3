class LimitedEditionArt < ElementBuild
  #LimitedEditionArt::LimitedEdition::AssocGroup.option
  def self.current_file
    File.basename(__FILE__, ".rb")
  end

  def self.current_dir
    File.expand_path(File.dirname(__FILE__)).split('/').last
  end

  ##############################################################################

  class LimitedEdition < LimitedEditionArt

    class AssocGroup < LimitedEdition
      def self.option
        [[assoc_key_attrs(:medium), [LimitedEditionPrint::LtdStandardPrint, LimitedEditionPrint::LtdPrintOnPaper, LimitedEditionPrint::LtdSericel, LimitedEditionPrint::LtdPhotograph]]]
      end
    end
  end

end
