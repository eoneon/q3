module Dimension

  def self.option_group
    self.constants.map {|konstant| konstant}
  end
  
  class BoxDimension
    extend Category

    def self.options
      %w[depth]
    end
  end

  class TwoDimension
    extend Category

    def self.options
      %w[width height]
    end
  end

  class ThreeDimension
    extend Category

    def self.options
      %w[width height depth]
    end
  end

  class SculptureDimension
    extend Category

    def self.options
      %w[width height depth weight]
    end
  end

end
