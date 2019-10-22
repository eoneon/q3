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
        BooleanTag.new.two_d
      ]
    end

    def sculpture_dimension
      [
        BooleanTag.new.three_d
      ]
    end
  end
end
