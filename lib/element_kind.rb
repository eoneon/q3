module ElementKind
  extend BuildSet
  extend HashTag

  ################################################################ ElementKind.pop_elements

  def self.pop_elements
    self.constants.each do |konstant|
      scoped_constant(konstant, :BooleanTag).instance_methods(false).each do |instance_method|
        scoped_constant(konstant, :BooleanTag).new.public_send(instance_method).each do |value|
          element = find_or_create_by(kind: to_snake(konstant), name: value)
          update_tags(element, h ={instance_method.to_s => 'true'})
        end
      end
    end
  end

  ################################################################ ElementKind.pop_elements

  module Medium
    class BooleanTag
      def primary
        %w[painting drawing mixed-media print sericel photography sculpture hand-blown hand-made]
      end

      def tertiary
        %w[embellished leafing remarque]
      end

      def component
        %w[diptych triptych quadriptych set]
      end

      def category
        %w[original one-of-a-kind hand-pulled production limited-edition single-edition open-edition]
      end
    end
  end

  module Material
    class BooleanTag

      def standard_flat
        %w[canvas paper board metal]
      end

      def photography
        %w[photography-paper]
      end

      def production_drawing
        %w[animation-paper]
      end

      def original_drawing
        %w[drawing-paper]
      end

      def sericel
        %w[sericel]
      end

      def standard_sculpture
        %w[glass ceramic metal synthetic]
      end

      def hand_blown
        %w[glass]
      end

      def hand_made
        %w[ceramic]
      end
    end
  end

  module Edition
    class BooleanTag
      def limited
        %w[numbered-xy numbered from-an-edition]
      end

      def single
        %w[single-edition]
      end

      def open
        %w[open-edition]
      end
    end
  end

  module Signature
    class BooleanTag
      def standard
        %w[artist relative celebrity]
      end

      def three_d
        %w[artist-3d]
      end
    end
  end

  module Certificate
    class BooleanTag
      def standard
        %w[standard-certificate publisher-certificate]
      end

      def animation
        %w[animation-seal sports-seal animation-certificate]
      end
    end
  end

  module Dimension
    class BooleanTag
      def two_d
        %w[width height]
      end

      def three_d
        %w[width height depth]
      end
    end
  end

  module Mounting
    class BooleanTag
      def two_d
        %w[framed bordered matted wall-mount]
      end

      def three_d
        %w[case base wall-mount]
      end
    end
  end
end
