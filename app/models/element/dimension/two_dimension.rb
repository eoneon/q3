class TwoDimension < ElementBuild

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

  class WidthHeight < TwoDimension

    class OptionGroup < WidthHeight
      def self.option
        #[[element_attrs, Dimension::WidthHeight::OptionValue.option]]
        [[element_attrs, option_values]]
      end
    end
  end

  class Diameter < TwoDimension

    class OptionGroup < Diameter
      def self.option
        #[[element_attrs, Dimension::Diameter::OptionValue.option]]
        [[element_attrs, option_values]]
      end
    end
  end

  #box
  class Depth < TwoDimension
    
    class OptionGroup < Depth
      def self.option
        #[[element_attrs, Dimension::Depth::OptionValue.option]]
        [[element_attrs, option_values]]
      end
    end
  end

end
