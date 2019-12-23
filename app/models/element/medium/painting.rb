class Painting < Medium
  #Painting::StandardPainting::OptionGroup.option
  def self.current_file
    File.basename(__FILE__, ".rb")
  end

  def self.current_dir
    File.expand_path(File.dirname(__FILE__)).split('/').last
  end

  def self.option_values
    scope_context(current_dir, origin, 'option_value')
  end

  def self.assoc_values
    scope_context(current_dir, origin, 'assoc_value')
  end

  def self.assoc_origin
    OriginalArt::Original
  end

  # def self.product_name(option_value)
  #   [assoc_origin.element_name, option_value, Painting.element_name].join(' ').split(' ').uniq.join(' ')
  # end

  def self.product_name(*names)
    [assoc_origin.element_name, Painting.element_name].join(' ').split(' ').uniq.join(' ')
  end

  ##############################################################################

  class StandardPainting < Painting

    class OptionGroup < StandardPainting
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < StandardPainting
      def self.option
        #[[assoc_key_attrs(:material), [PaperMaterial::Paper, CanvasMaterial::Canvas, Board::Wood, Board::Acrylic, MetalMaterial::Metal, Box::MetalBox, Box::MetalBox]]]
        [[assoc_key_attrs(:material), assoc_values]]
      end
    end

  end

  class PaintingOnPaper < Painting

    class OptionGroup < PaintingOnPaper
      def self.option
        [[element_attrs, option_values]]
      end
    end

    class AssocGroup < PaintingOnPaper
      def self.option
        [[assoc_key_attrs(:material), [PaperMaterial::Paper]]]
      end
    end
  end

end

# def self.option_attrs
#   tags = element_tags.merge(h={product_name: product_name(element_name)})
#   attrs = element_attrs
#   attrs[:tags] = tags
#   attrs
# end
