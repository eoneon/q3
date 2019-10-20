module Material
  class BooleanTag
    def flat_signature
      %w[canvas paper board metal photography-paper animation-paper drawing-paper sericel]
    end

    def sculpture_signature
      %w[glass ceramic metal synthetic]
    end

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
