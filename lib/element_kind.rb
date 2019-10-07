module ElementKind
  extend BuildSet
  extend HashTag

  def self.pop_elements
    self.constants.each do |konstant|
      scoped_constant = scoped_constant(konstant)                               #ElementKind::Medium
      scoped_constant.instance_methods(false).each do |instance_method|
        scoped_constant.new.public_send(instance_method).each do |element_name|
          element = find_or_create_by(kind: kind = to_snake(konstant), name: element_name)
          update_tags(element, h ={instance_method.to_s => 'true'})
        end
      end
    end
  end

  class Medium
    def primary
      %w[painting drawing mixed-media print sericel sculpture hand-blown hand-made]
    end

    def secondary
      %w[embellished hand-pulled sculpture-type]
    end

    def tertiary
      %w[leafing remarque]
    end

    def component
      %w[diptych triptych quadriptych set]
    end

    def category
      %w[original one-of-a-kind production limited-edition single-edition open-edition]
    end
  end

  class Material
    def standard
      %w[canvas paper board metal]
    end

    def photography
      %w[photography-paper]
    end

    def sericel
      %w[sericel]
    end

    def sculpture
      %w[glass ceramic metal synthetic]
    end

    def hand_blown
      %w[glass]
    end

    def hand_made
      %w[ceramic]
    end
  end

  class Edition
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

  class Signature
    def standard
      %w[artist relative celebrity]
    end

    def three_d
      %w[artist-3d]
    end
  end

  class Certificate
    def standard
      %w[standard-certificate publisher-certificate]
    end

    def animation
      %w[animation-seal sports-seal animation-certificate]
    end
  end

  class Dimension
    def two_d
      %w[width height]
    end

    def three_d
      %w[width height depth]
    end
  end

  class Mounting
    def two_d
      %w[framed bordered matted wall-mount]
    end

    def three_d
      %w[case base wall-mount]
    end
  end
end
