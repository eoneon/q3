class StandardSculptureMedium < Medium

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

  class StandardSculpture < StandardSculptureMedium

    class OptionGroup < StandardSculpture
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < StandardSculpture
      def self.option
        [[assoc_key_attrs(:material), [Material::Glass, Material::Ceramic, Material::Bronze, Material::Synthetic, Material::Stone]]]
      end
    end
  end

end
