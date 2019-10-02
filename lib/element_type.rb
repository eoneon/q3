module ElementType

  def self.types_and_constants
    self.constants.map {|type| [type, [self.name, type].join('::')]}
  end

  class Medium
    ################################################################### boolean_tags, text_tags, names
    def self.boolean_tags
      %w[primary secondary tertiary category component category]
    end

    def self.text_tags
      ['material', %w[painting drawing mixed-media print].prepend('standard'), %w[photography], %w[sericel], %w[hand-blown], %w[hand-made], %w[sculpture]]
    end

    def self.names
      primary | secondary | tertiary | component | category
    end

    ################################################################### scoped names

    def self.primary
      %w[painting drawing mixed-media print sericel sculpture hand-blown hand-made]
    end

    def self.secondary
      %w[embellished hand-pulled sculpture-type]
    end

    def self.tertiary
      %w[leafing remarque]
    end

    def self.component
      %w[diptych triptych quadriptych set]
    end

    def self.category
      %w[original one-of-a-kind production limited-edition single-edition open-edition]
    end
  end

  class Material
    ################################################################### boolean_tags, text_tags, names
    def self.boolean_tags
      %w[standard photography sericel sculpture hand-blown hand-made]
    end

    def self.names
      standard | photography | sericel | sculpture | hand_blown | hand_made
    end

    def self.standard
      %w[canvas paper board metal]
    end

    def self.photography
      %w[photography-paper]
    end

    def self.sericel
      %w[sericel]
    end

    def self.sculpture
      %w[glass ceramic metal synthetic]
    end

    def self.hand_blown
      %w[glass]
    end

    def self.hand_made
      %w[hand-made]
    end
  end

  class Edition
    ################################################################### boolean_tags, text_tags, names
    def self.boolean_tags
      %w[limited single open]
    end

    def self.names
      limited | single | open
    end

    def self.limited
      %w[numbered-xy numbered from-an-edition]
    end

    def self.single
      %w[sericel]
    end

    def self.open
      %w[open-edition]
    end
  end

  class Signature
    ################################################################### boolean_tags, text_tags, names
    def self.boolean_tags
      %w[standard three-d]
    end

    def self.names
      standard | three_d
    end

    def self.standard
      %w[numbered-xy numbered from-an-edition]
    end

    def self.three_d
      %w[sericel]
    end
  end

  class Certificate
    ################################################################### boolean_tags, text_tags, names
    def self.boolean_tags
      %w[standard animation]
    end

    def self.names
      standard | animation
    end

    def self.standard
      %w[standard-certificate publisher-certificate]
    end

    def self.animation
      %w[animation-seal sports-seal animation-certificate]
    end
  end

  class Dimension
    ################################################################### boolean_tags, text_tags, names
    def self.boolean_tags
      %w[two-d three-d]
    end

    def self.names
      two_d | three_d
    end

    def self.two_d
      %w[width height]
    end

    def self.three_d
      %w[width height depth]
    end
  end

  class Mounting
    ################################################################### boolean_tags, text_tags, names
    def self.boolean_tags
      %w[two-d three-d]
    end

    def self.names
      two_d | three_d
    end

    def self.two_d
      %w[framed bordered matted wall-mount]
    end

    def self.three_d
      %w[case base wall-mount]
    end
  end
end
