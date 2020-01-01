class ThreeDimensionMounting < Mounting

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

  class ThreeDimension < ThreeDimensionMounting

    class OptionGroup < ThreeDimension
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < ThreeDimension
      def self.option
        [[assoc_key_attrs(:dimension), [Dimension::WidthHeightDepth]]]
      end
    end
  end

end
