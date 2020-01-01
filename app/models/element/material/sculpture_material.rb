class SculptureMaterial < Material

  def self.current_file
    File.basename(__FILE__, ".rb")
  end

  def self.current_dir
    File.expand_path(File.dirname(__FILE__)).split('/').last
  end

  # def self.option_values
  #   scope_context(current_dir, origin, 'option_value').option
  # end
  # end  Glass::AssocGroup

  ##############################################################################

  class Glass < SculptureMaterial

    class OptionGroup < Glass
      def self.option
        [[element_attrs, option_values]]
        #[[element_attrs, Material::Sericel::OptionValue.option]]
      end
    end

    class AssocGroup < Glass
      def self.option
        [[assoc_key_attrs(:dimension), [Dimension::WidthHeightDepthWeight, Dimension::DiameterHeightWeight, Dimension::DiameterWeight]], [assoc_key_attrs(:mounting), [ThreeDimensionMounting::ThreeDimension]]]
      end
    end
  end

  class Ceramic < SculptureMaterial

    class OptionGroup < Ceramic
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < Ceramic
      def self.option
        [[assoc_key_attrs(:dimension), [Dimension::WidthHeightDepthWeight, Dimension::DiameterHeightWeight, Dimension::DiameterWeight]], [assoc_key_attrs(:mounting), [ThreeDimensionMounting::ThreeDimension]]]
      end
    end
  end

  class Bronze < SculptureMaterial

    class OptionGroup < Bronze
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < Bronze
      def self.option
        [[assoc_key_attrs(:dimension), [Dimension::WidthHeightDepthWeight, Dimension::DiameterHeightWeight, Dimension::DiameterWeight]], [assoc_key_attrs(:mounting), [ThreeDimensionMounting::ThreeDimension]]]
      end
    end
  end

  class Synthetic < SculptureMaterial

    class OptionGroup < Synthetic
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < Synthetic
      def self.option
        [[assoc_key_attrs(:dimension), [Dimension::WidthHeightDepthWeight, Dimension::DiameterHeightWeight, Dimension::DiameterWeight]], [assoc_key_attrs(:mounting), [ThreeDimensionMounting::ThreeDimension]]]
      end
    end
  end

  class Stone < SculptureMaterial

    class OptionGroup < Stone
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < Stone
      def self.option
        [[assoc_key_attrs(:dimension), [Dimension::WidthHeightDepthWeight, Dimension::DiameterHeightWeight, Dimension::DiameterWeight]], [assoc_key_attrs(:mounting), [ThreeDimensionMounting::ThreeDimension]]]
      end
    end
  end

end
