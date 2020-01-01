class TwoDimensionMounting < Mounting

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

  class TwoDimension < TwoDimensionMounting

    class OptionGroup < TwoDimension
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < TwoDimension
      def self.option
        [[assoc_key_attrs(:dimension), [Dimension::WidthHeight, Dimension::Diameter]]]
      end
    end
  end

  class CanvasMounting < TwoDimensionMounting

    class OptionGroup < CanvasMounting
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < CanvasMounting
      def self.option
        [[assoc_key_attrs(:dimension), [Dimension::WidthHeight, Dimension::Diameter, Dimension::Depth]]]
      end
    end
  end

  class BoxMounting < TwoDimensionMounting

    class OptionGroup < BoxMounting
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < BoxMounting
      def self.option
        [[assoc_key_attrs(:dimension), [Dimension::Depth]]]
      end
    end
  end

  class SericelMounting < TwoDimensionMounting

    class OptionGroup < SericelMounting
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < SericelMounting
      def self.option
        [[assoc_key_attrs(:dimension), [Dimension::WidthHeight]]]
      end
    end
  end

end
