module Material

  def self.on_material
    standard_flat | photography_paper | production_drawing_paper
  end

  def self.standard_flat
    %w[canvas paper board metal]
  end

  def self.photography_paper
    ['photography paper']
  end

  def self.production_drawing_paper
    ['animation paper']
  end

  ##############################################################################



  ##############################################################################

  class BooleanTag
    def flat_signature
      %w[canvas paper board metal photography-paper animation-paper drawing-paper sericel]
    end

    def sculpture_signature
      #%w[glass ceramic metal synthetic]
      standard_sculpture
    end

    def standard_flat
      %w[canvas paper board metal]
    end

    # def photography
    #   %w[photography-paper]
    # end
    #
    # def production_drawing
    #   %w[animation-paper]
    # end
    def photography_paper
      ['photography paper']
    end

    def production_drawing_paper
      ['animation paper']
    end

    def on_material
      standard_flat | photography_paper | production_drawing_paper
    end

    def original_drawing
      %w[drawing-paper]
    end

    def sericel
      %w[sericel]
    end

    def standard_sculpture
      #%w[glass ceramic metal synthetic]
      %w[glass ceramic bronze acrylic pewter lucite mixed-media]
    end

    def hand_blown
      %w[glass]
    end

    def hand_made
      %w[ceramic]
    end
  end
end
