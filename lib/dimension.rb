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
