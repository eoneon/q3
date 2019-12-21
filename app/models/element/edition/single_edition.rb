class SingleEdition < Edition

  def self.current_file
    File.basename(__FILE__, ".rb")
  end

  def self.current_dir
    File.expand_path(File.dirname(__FILE__)).split('/').last
  end

  ##############################################################################

  class NumberedOneOfOne < SingleEdition
    class OptionGroup < NumberedOneOfOne
      def self.option
        [[edition_attrs(:proof_option), Edition::Proof::OptionValue.option]]
      end
    end
  end
end
