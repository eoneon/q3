module Material

  def self.flat_dimension_material
    on_material | sericel_material
  end

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
