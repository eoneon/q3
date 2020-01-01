class MetalMaterial < Material

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

  class Metal < MetalMaterial

    class OptionGroup < Metal
      def self.option
        #[[element_attrs, Material::Metal::OptionValue.option]]
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < Metal
      def self.option
        [[assoc_key_attrs(:dimension), [Dimension::WidthHeight]], [assoc_key_attrs(:mounting), [TwoDimensionMounting::TwoDimension]]]
      end
    end
  end

end
