class CanvasMaterial < Material

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

  class Canvas < CanvasMaterial

    class OptionGroup < Canvas
      def self.option
        #[[element_attrs, Material::Canvas::OptionValue.option]]
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < Canvas
      def self.option
        [[assoc_key_attrs(:dimension), [Dimension::WidthHeight]], [assoc_key_attrs(:mounting), [TwoDimensionMounting::TwoDimension, TwoDimensionMounting::CanvasMounting]]]
      end
    end
  end

end


  # class WrappedCanvas < Canvas
  #   def self.canvas_options
  #     ['gallery wrapped canvas', 'stretched canvas']
  #   end
  # end
