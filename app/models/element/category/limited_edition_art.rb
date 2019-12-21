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
        [[assoc_key_attrs(:medium), LimitedEditionPrint.constants.map {|konstant| scope_context(LimitedEditionPrint, konstant)}]]
      end
    end
  end

  # class OneOfAKind < OriginalArt
  #
  #   class AssocGroup < OneOfAKind
  #     def self.option
  #       [[assoc_key_attrs(:medium), [MixedMedium::StandardMixedMedium, MixedMedium::PeterMaxMixedMedium, MixedMedium::Etching, MixedMedium::HandPulled]]]
  #     end
  #   end
  #
  # end
end
