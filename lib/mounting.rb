module Mounting
  class BooleanTag
    def two_d
      %w[framed bordered matted wall-mount]
    end

    def three_d
      %w[case base wall-mount]
    end
  end

  class OptionGroupSet
    def flat_mounting
      [
        %w[framed], %w[bordered], %w[matted], %w[wall-mount]
      ]
    end

    def sculpture_mounting
      [
        %w[case], %w[base], %w[wall-mount]
      ]
    end
  end
end
