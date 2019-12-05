module Mounting

  def self.option_group
    self.constants.map {|konstant| konstant}
  end

  class FlatMounting
    extend Category

    def self.options
      %w[framed bordered matted wall-mount]
    end

    def self.dimension
      Dimension::TwoDimension
    end
  end

  class CanvasMounting
    extend Category

    def self.options
      ['framed', 'gallery wrapped', 'stretched', 'matted']
    end

    def self.dimension
      Dimension::TwoDimension
    end
  end

  class BoxMounting
    extend Category

    def self.options
      ['gallery wrapped', 'box']
    end

    def self.dimension
      Dimension::BoxDimension
    end
  end

  class SericelMounting
    extend Category

    def self.options
      %w[framed matted]
    end

    def self.dimension
      Dimension::TwoDimension
    end
  end

  class SculptureMounting
    extend Category

    def self.options
      %w[case base wall-mount stand]
    end

    def self.dimension
      Dimension::SculptureDimension
    end
  end

end

# class Material < Category::Original
#
#   def flat_mounting_names
#     %w[framed bordered matted wall-mount]
#   end
#
#   def canvas_mounting_names
#     ['framed', 'gallery wrapped', 'stretched', 'matted']
#   end
#
#   def sericel_mounting_names
#     %w[framed matted]
#   end
#
#   def sculpture_mounting_names
#     %w[case base wall-mount stand]
#   end
# end

##############################################################################

# module MaterialMounting
#   def self.options
#     option_set.map {|set| set.last}
#   end
#
#   def self.add_mounting(combo_set, mountings)
#     set = []
#     combo_set.each do |combo|
#       if material = combo.detect {|obj| obj.kind == 'material'}
#         mounting_name = MaterialMounting.detect {|set| set.first.include?(material.name)}.last
#         set << combo << find_or_create_by(kind: 'mounting', name: mounting_name)
#       else
#         set << combo
#       end
#     end
#     set
#   end
#
#   def self.option_set
#     [
#       [%w[paper board wood metal], 'flat mounting'],
#       [%w[canvas], 'canvas mounting'],
#       [%w[sericel], 'sericel mounting'],
#       [Material.standard_sculpture, 'sculpture mounting']
#     ]
#   end
# end
