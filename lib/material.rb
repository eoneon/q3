module Material

  def self.all_material
    flat_dimension_material | standard_sculpture
  end

  def self.flat_dimension_material
    on_material | sericel_material
  end

  def self.on_material
    standard_flat | photography_paper | production_drawing_paper
  end

  def self.standard_flat
    %w[canvas paper board metal]
  end

  # def self.canvas_options
  #   ['canvas', 'canvas board', 'textured canvas']
  # end

  # def self.paper_options
  #   ['paper', 'deckle edge paper', 'rice paper', 'arches paper', 'sommerset paper', 'mother of pearl paper']
  # end

  # def self.board_options
  #   ['board', 'wood', 'wood panel', 'acrylic panel']
  # end

  def self.photography_paper
    ['photography paper']
  end

  # def self.photography_paper_options
  #   ['paper', 'photography paper', 'archival grade paper']
  # end

  def self.production_drawing_paper
    ['animation paper']
  end

  def self.sericel_material
    ['sericel', 'sericel with background', 'sericel with lithographic background']
  end

  ##############################################################################

  def self.standard_sculpture
    ['glass', 'ceramic', 'bronze', 'acrylic', 'pewter', 'lucite', 'mixed media']
  end

  def self.hand_blown
    %w[glass]
  end

  def self.hand_made
    %w[ceramic]
  end
end
