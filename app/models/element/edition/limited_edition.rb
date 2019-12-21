class LimitedEdition < Edition
  #LimitedEdition::NumberedXy::OptionGroup.option
  def self.current_file
    File.basename(__FILE__, ".rb")
  end

  def self.current_dir
    File.expand_path(File.dirname(__FILE__)).split('/').last
  end

  ##############################################################################

  class NumberedXy < LimitedEdition
    class OptionGroup < NumberedXy
      def self.option
        [[edition_attrs(:proof_option), Edition::Proof::OptionValue.option], [edition_attrs(:limited_edition_option), Edition::Limited::OptionValue.option]]
      end
    end
  end

  class RomanNumberedXy < LimitedEdition
    class OptionGroup < NumberedXy
      def self.option
        [[edition_attrs(:proof_option), Edition::Proof::OptionValue.option], [edition_attrs(:limited_edition_option), Edition::Limited::OptionValue.option]]
      end
    end
  end

  class NumberedQty < LimitedEdition
    class OptionGroup < NumberedXy
      def self.option
        [[edition_attrs(:proof_option), Edition::Proof::OptionValue.option], [edition_attrs(:limited_edition_option), Edition::Limited::OptionValue.option]]
      end
    end
  end

  class ProofEdition < LimitedEdition
    class OptionGroup < ProofEdition
      def self.option
        [[edition_attrs(:proof_option), Edition::Proof::OptionValue.option], [edition_attrs(:limited_edition_option), Edition::Limited::OptionValue.option]]
      end
    end
  end
end
