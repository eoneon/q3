class UniqueSculptureMedium < Medium

  def self.current_file
    File.basename(__FILE__, ".rb")
  end

  def self.current_dir
    File.expand_path(File.dirname(__FILE__)).split('/').last
  end

  def self.option_values
    scope_context(current_dir, origin, 'option_value').option
  end

  ##############################################################################

  class HandBlownGlass < UniqueSculptureMedium

    class OptionGroup < HandBlownGlass
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < HandBlownGlass
      def self.option
        [[assoc_key_attrs(:material), [Material::Glass]]]
      end
    end
  end

  class HandMadeCeramic < UniqueSculptureMedium

    class OptionGroup < HandMadeCeramic
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < HandMadeCeramic
      def self.option
        [[assoc_key_attrs(:material), [Material::Ceramic]]]
      end
    end
  end

  # class GartnerBlade < UniqueSculpture
  #   def self.option_values
  #     ['hand made ceramic sculpture']
  #   end
  #
  #   def self.materials
  #   end
  # end

end
