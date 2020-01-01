class PaperMaterial < Material
  # PaperMaterial::Paper::OptionGroup.option
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


  class Paper < PaperMaterial

    class OptionGroup < Paper
      def self.option
        #[[element_attrs, 'wtf']]
        #[[element_attrs, Material::Paper::OptionValue]]
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < Paper
      def self.option
        [[assoc_key_attrs(:dimension), [Dimension::WidthHeight]], [assoc_key_attrs(:mounting), [TwoDimensionMounting::TwoDimension]]]
      end
    end
  end

  class PhotographyPaper < PaperMaterial

    class OptionGroup < PhotographyPaper
      def self.option
        #[[element_attrs, Material::PhotographyPaper::OptionValue]]
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < PhotographyPaper
      def self.option
        [[assoc_key_attrs(:dimension), [Dimension::WidthHeight]], [assoc_key_attrs(:mounting), [TwoDimensionMounting::TwoDimension]]]
      end
    end
  end

  class AnimationPaper < PaperMaterial

    class OptionGroup < AnimationPaper
      def self.option
        #[[element_attrs, Material::AnimationPaper::OptionValue]]
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < AnimationPaper
      def self.option
        [[assoc_key_attrs(:dimension), [Dimension::WidthHeight]], [assoc_key_attrs(:mounting), [TwoDimensionMounting::TwoDimension]]]
      end
    end
  end

end
