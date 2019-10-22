module Medium
  class BooleanTag
    def primary
      %w[painting drawing mixed-media print sericel photography sculpture hand-blown hand-made]
    end

    def secondary
      %w[embellished]
    end

    def tertiary
      %w[leafing remarque]
    end

    def component
      %w[diptych triptych quadriptych set]
    end

    def category
      %w[original one-of-a-kind hand-pulled production limited-edition single-edition open-edition]
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
  end

end
