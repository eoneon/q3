class Edition < ElementBuild

  def self.current_file
    File.basename(__FILE__, ".rb")
  end

  def self.current_dir
    File.expand_path(File.dirname(__FILE__)).split('/').last
  end

  ##############################################################################

  class Limited < Edition

    class OptionValue < Limited
      def self.option
        ['limited edition', 'sold out limited edition', 'unique variation']
      end
    end
  end

  class Proof < Edition

    class OptionValue < Proof
      def self.option
        ['AP', 'EA', 'CP', 'GP', 'PP', 'IP', 'HC', 'TC', 'Japanese']
      end
    end
  end

  def self.edition_attrs(edition)
    h = {name: edition.to_s, kind: element_kind, tags: element_tags}
  end
end
