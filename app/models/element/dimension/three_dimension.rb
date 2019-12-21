class ThreeDimension < ElementBuild

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

  #material
  class DiameterHeightWeight < ThreeDimension

    class OptionGroup < DiameterHeightWeight
      def self.option
        [[element_attrs, option_values]] #Dimension::DiameterHeightWeight::OptionValue.option
      end
    end
  end

  class DiameterWeight < ThreeDimension

    class OptionGroup < DiameterWeight
      def self.option
        #[[element_attrs, Dimension::DiameterWeight::OptionValue.option]]
        [[element_attrs, option_values]]
      end
    end
  end

  class WidthHeightDepthWeight < ThreeDimension

    class OptionGroup < WidthHeightDepthWeight
      def self.option
        #[[element_attrs, Dimension::WidthHeightDepthWeight::OptionValue.option]]
        [[element_attrs, option_values]]
      end
    end
  end

  #mounting
  class WidthHeightDepth < ThreeDimension

    class OptionGroup < WidthHeightDepth
      def self.option
        #[[element_attrs, Dimension::WidthHeightDepth::OptionValue.option]]
        [[element_attrs, option_values]]
      end
    end
  end
  
end
