module Dimension
  class BooleanTag
    def two_d
      %w[width height]
    end

    def three_d
      %w[width height depth]
    end
  end

  class OptionGroupSet
    def flat_dimension
      [
        %w[width height]
      ]
    end

    def sculpture_dimension
      [
        %w[width height depth]
      ]
    end
  end

  class OptionGroupMatch
    def flat_dimension
      h ={kind: 'medium', name: %w[painting drawing mixed-media print sericel photography]}
    end
  end

  class OptionGroupMatch
    def sculpture_dimension
      h ={kind: 'medium', name: 'sculpture'}
    end
  end
end
