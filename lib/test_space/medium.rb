module Medium
  class BooleanTag
    # def primary
    #   %w[painting drawing mixed-media standard-print hand-pulled-print sericel photography sculpture hand-blown hand-made]
    # end

    def primary
      %w[painting drawing mixed-media standard-print hand-pulled-silkscreen sericel photography sculpture hand-blown hand-made]
    end

    def paint_media
      %w[oil acrylic mixed-media watercolor guash sumi-ink]
    end

    def standard_print_media
      %w[etching lithograph poster giclee serigraph mixed-media-print]
    end

    def print_media
      %w[sericel photography] | canvas_only | paper_only | standard_material
    end

    ###################

    def canvas_only
      %w[hand-pulled-silkscreen]
    end

    def paper_only
      %w[watercolor guash sumi-ink etching lithograph poster]
    end

    def standard_flat_material
      %w[oil acrylic mixed-media giclee serigraph mixed-media-print]
    end

    ###################

    def drawing_media
      %w[pencil pen-and-ink]
    end

    def sericel_media
      %w[hand-painted]
    end

    def mixed_media
      %w[acrylic-mixed-media mixed-media-overpaint]
    end

    def embellishment
      %w[embellished]
    end

    def embellish_media
      %w[hand-embellished artist-embellished hand-painted hand-tinted]
    end

    def tertiary
      %w[leafing remarque]
    end

    def leafing_media
      %w[gold-leaf silver-leaf]
    end

    def remarque_media
      %w[hand-drawn-remarque]
    end

    def component
      %w[diptych triptych quadriptych set]
    end

    def category
      %w[original one-of-a-kind production limited-edition single-edition open-edition]
    end

    def sculpture_type
      %w[vase flat-vase bowl jar pumpkin heart luminaire]
    end
  end

  class OptionGroupSet
    def sub_media
      [
        %w[leafing],
        %w[remarque],
        %w[leafing remarque]
      ]
    end

    # def sculpture_type
    #   [
    #     %w[vase], %w[flat vase], %w[bowl], %w[jar], %w[pumpkin], %w[heart], %w[luminaire]
    #   ]
    # end
  end

  class OptionGroupMatch
    def sub_media
      h ={kind: 'medium', name: %w[standard-print hand-pulled-print]}
    end

    # def sculpture_type
    #   h ={kind: 'medium', name: 'sculpture'}
    # end
  end
end
