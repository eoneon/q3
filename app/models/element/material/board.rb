class Board < Material

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

  class Wood < Board

    class OptionGroup < Wood
      def self.option
        #[[element_attrs, Material::Wood::OptionValue.option]]
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < Wood
      def self.option
        [[assoc_key_attrs(:dimension), [Dimension::WidthHeight]], [assoc_key_attrs(:mounting), [TwoDimensionMounting::TwoDimension]]]
      end
    end
  end

  class Acrylic < Board

    class OptionGroup < Acrylic
      def self.option
        #[[element_attrs, Material::Acrylic::OptionValue.option]]
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < Acrylic
      def self.option
        [[assoc_key_attrs(:dimension), [Dimension::WidthHeight]], [assoc_key_attrs(:mounting), [TwoDimensionMounting::TwoDimension]]]
      end
    end
  end

end
