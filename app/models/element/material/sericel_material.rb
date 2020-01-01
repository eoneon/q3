class SericelMaterial < Material

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

  class Sericel < SericelMaterial

    class OptionGroup < Sericel
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < Sericel
      def self.option
        [[assoc_key_attrs(:dimension), [Dimension::WidthHeight]], [assoc_key_attrs(:mounting), [TwoDimensionMounting::SericelMounting]]]
      end
    end
  end

end
