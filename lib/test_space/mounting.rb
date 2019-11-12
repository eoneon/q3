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

  class OptionGroupMatch
    def flat_mounting
      #h ={kind: 'medium', name: %w[painting drawing mixed-media print sericel photography]}
      h ={kind: 'medium', name: %w[painting drawing mixed-media standard-print hand-pulled-print sericel photography]}
    end
  end

  class OptionGroupMatch
    def sculpture_mounting
      h ={kind: 'medium', name: 'sculpture'}
    end
  end
end
