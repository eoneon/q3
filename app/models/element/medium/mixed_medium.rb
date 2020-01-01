class MixedMedium < Medium

  def self.current_file
    File.basename(__FILE__, ".rb")
  end

  def self.current_dir
    File.expand_path(File.dirname(__FILE__)).split('/').last
  end

  # def self.option_values
  #   scope_context(current_dir, origin, 'option_value').option
  # end 

  ##############################################################################

  class StandardMixedMedium < MixedMedium

    class OptionGroup < StandardMixedMedium
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < StandardMixedMedium
      def self.option
        [[assoc_key_attrs(:material), assoc_values]]
      end
    end
  end

  class PeterMaxMixedMedium < MixedMedium

    class OptionGroup < PeterMaxMixedMedium
      def self.option
        [[element_attrs, Medium::StandardMixedMedium::OptionValue]]
      end
    end

    class AssocGroup < PeterMaxMixedMedium
      def self.option
        [[assoc_key_attrs(:material), [PaperMaterial::Paper]]]
      end
    end
  end

  class Etching < MixedMedium

    class OptionGroup < Etching
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < Etching
      def self.option
        [[assoc_key_attrs(:material), assoc_values]]
      end
    end
  end

  class HandPulled < MixedMedium

    class OptionGroup < HandPulled
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < HandPulled
      def self.option
        [[assoc_key_attrs(:material), [CanvasMaterial::Canvas]]]
      end
    end
  end

end
