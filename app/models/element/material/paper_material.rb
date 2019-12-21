class PaperMaterial < Material

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


  class Paper < PaperMaterial

    class OptionGroup < Paper
      def self.option
        #[[element_attrs, Material::Paper::OptionValue.option]]
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < Paper
      def self.option
        [[assoc_key_attrs(:dimension), [Dimension::WidthHeight]], [assoc_key_attrs(:mounting), [TwoDimensionMounting::TwoDimension]]]
      end
    end
  end

  class PhotographyPaper < PaperMaterial

    class OptionGroup < PhotographyPaper
      def self.option
        #[[element_attrs, Material::PhotographyPaper::OptionValue.option]]
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < PhotographyPaper
      def self.option
        [[assoc_key_attrs(:dimension), [Dimension::WidthHeight]], [assoc_key_attrs(:mounting), [TwoDimensionMounting::TwoDimension]]]
      end
    end
  end

  class AnimationPaper < PaperMaterial

    class OptionGroup < AnimationPaper
      def self.option
        #[[element_attrs, Material::AnimationPaper::OptionValue.option]]
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < AnimationPaper
      def self.option
        [[assoc_key_attrs(:dimension), [Dimension::WidthHeight]], [assoc_key_attrs(:mounting), [TwoDimensionMounting::TwoDimension]]]
      end
    end
  end

  #
  # class SculptureMaterial
  #   extend Category
  #
  #   def self.options
  #     [Glass, Ceramic, Bronze, Synthetic, Stone].map {|konstant| konstant.to_s.split('::').last.underscore.split('_').join(' ')}
  #   end
  #
  #   def self.mounting
  #     Mounting::SculptureMounting
  #   end
  # end
  #

  # class Metal
  #   extend Category
  #
  #   def self.options
  #     ['metal', 'metal panel', 'aluminum', 'aluminum panel']
  #   end
  #
  #   def self.mounting
  #     Mounting::FlatMounting
  #   end
  # end
  #
  # class Box
  #   extend Category
  #
  #   def self.options
  #     ['canvas box', 'wood box', 'metal box']
  #   end
  #
  #   def self.mounting
  #     Mounting::BoxMounting
  #   end
  # end
  #

  #
  # class Sericel
  #   extend Category
  #
  #   def self.options
  #     ['sericel', 'sericel with background', 'sericel with lithographic background']
  #   end
  #
  #   def self.mounting
  #     Mounting::SericelMounting
  #   end
  # end
  #
  # class Glass < SculptureMaterial
  #   extend Category
  #
  #   def self.options
  #     ['glass']
  #   end
  # end
  #
  # class Ceramic < SculptureMaterial
  #   extend Category
  #
  #   def self.options
  #     ['ceramic']
  #   end
  # end
  #
  # class Bronze < SculptureMaterial
  #   extend Category
  #
  #   def self.options
  #     ['bronze']
  #   end
  # end
  #
  # class Synthetic < SculptureMaterial
  #   extend Category
  #
  #   def self.options
  #     ['acrylic', 'lucite', 'mixed media']
  #   end
  # end
  #
  # class Stone < SculptureMaterial
  #   extend Category
  #
  #   def self.options
  #     ['pewter']
  #   end
  # end
end
