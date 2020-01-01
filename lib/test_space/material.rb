module Material
#   extend Mounting
#
#   def self.option_group
#     self.constants.map {|konstant| konstant}[2..-1]
#   end
#
#   class PaintingMaterial
#     extend Category
#
#     def self.options
#       [
#         [
#           'canvas', ['standard canvas', ['canvas', 'canvas board', 'textured canvas']]
#         ],
#
#         [
#           'canvas', ['boxed canvas', ['canvas', 'textured canvas']]
#         ],
#         [
#           'paper', ['standard paper', ['paper', 'deckle edge paper', 'rice paper', 'arches paper', 'sommerset paper', 'mother of pearl paper']]
#         ]
#       ]
#     end
#
#     def self.options
#       [Canvas, StandardPaper, Board, Metal].map {|konstant| konstant.to_s.split('::').last.underscore.split('_').join(' ')}
#     end
#
#     def self.standard_material_names
#       two_d_material | three_d_material
#     end
#
#     def self.two_d_material
#       ['canvas', 'standard paper', 'board', 'wood', 'metal']
#     end
#
#     def self.three_d_material
#       ["wood box", "metal box"]
#     end
#   end
#   # class PaintingMaterial
#   #   extend Category
#   #
#   #   def self.options
#   #     [
#   #       [
#   #         'canvas', ['standard canvas', ['canvas', 'canvas board', 'textured canvas']]
#   #       ],
#   #
#   #       [
#   #         'canvas', ['boxed canvas', ['canvas', 'textured canvas']]
#   #       ],
#   #       [
#   #         'paper', ['standard paper', ['paper', 'deckle edge paper', 'rice paper', 'arches paper', 'sommerset paper', 'mother of pearl paper']]
#   #       ]
#   #     ]
#   #   end
#   #
#   #   def self.options
#   #     [Canvas, StandardPaper, Board, Metal].map {|konstant| konstant.to_s.split('::').last.underscore.split('_').join(' ')}
#   #   end
#   #
#   #   def self.standard_material_names
#   #     two_d_material | three_d_material
#   #   end
#   #
#   #   def self.two_d_material
#   #     ['canvas', 'standard paper', 'board', 'wood', 'metal']
#   #   end
#   #
#   #   def self.three_d_material
#   #     ["wood box", "metal box"]
#   #   end
#   # end
#
#   class SculptureMaterial
#     extend Category
#
#     def self.options
#       [Glass, Ceramic, Bronze, Synthetic, Stone].map {|konstant| konstant.to_s.split('::').last.underscore.split('_').join(' ')}
#     end
#
#     def self.mounting
#       Mounting::SculptureMounting
#     end
#   end
#
#   class Canvas
#     extend Category
#
#     # def self.options
#     #   ['canvas', 'canvas board', 'textured canvas']
#     # end
#
#     def self.options
#       [
#         [
#           'canvas', ['standard canvas', ['canvas', 'canvas board', 'textured canvas']]
#         ],
#
#         [
#           'canvas', ['boxed canvas', ['canvas', 'textured canvas']]
#         ]
#       ]
#     end
#
#     def self.mounting
#       Mounting::CanvasMounting
#     end
#   end
#
#   class StandardPaper
#     extend Category
#
#     def self.options
#       ['paper', 'deckle edge paper', 'rice paper', 'arches paper', 'sommerset paper', 'mother of pearl paper']
#     end
#
#     def self.mounting
#       Mounting::FlatMounting
#     end
#   end
#
#   class Board
#     extend Category
#
#     def self.options
#       ['board', 'wood', 'wood panel', 'acrylic', 'acrylic panel']
#     end
#
#     def self.mounting
#       Mounting::FlatMounting
#     end
#   end
#
#   class Metal
#     extend Category
#
#     def self.options
#       ['metal', 'metal panel', 'aluminum', 'aluminum panel']
#     end
#
#     def self.mounting
#       Mounting::FlatMounting
#     end
#   end
#
#   class Box
#     extend Category
#
#     def self.options
#       ['canvas box', 'wood box', 'metal box']
#     end
#
#     def self.mounting
#       Mounting::BoxMounting
#     end
#   end
#
#   class PhotographyPaper
#     extend Category
#
#     def self.options
#       ['paper', 'photography paper', 'archival grade paper']
#     end
#
#     def self.mounting
#       Mounting::FlatMounting
#     end
#   end
#
#   class AnimationPaper
#     extend Category
#
#     def self.options
#       ['paper', 'animation paper']
#     end
#
#     def self.mounting
#       Mounting::FlatMounting
#     end
#   end
#
#   class Sericel
#     extend Category
#
#     def self.options
#       ['sericel', 'sericel with background', 'sericel with lithographic background']
#     end
#
#     def self.mounting
#       Mounting::SericelMounting
#     end
#   end
#
#   class Glass < SculptureMaterial
#     extend Category
#
#     def self.options
#       ['glass']
#     end
#   end
#
#   class Ceramic < SculptureMaterial
#     extend Category
#
#     def self.options
#       ['ceramic']
#     end
#   end
#
#   class Bronze < SculptureMaterial
#     extend Category
#
#     def self.options
#       ['bronze']
#     end
#   end
#
#   class Synthetic < SculptureMaterial
#     extend Category
#
#     def self.options
#       ['acrylic', 'lucite', 'mixed media']
#     end
#   end
#
#   class Stone < SculptureMaterial
#     extend Category
#
#     def self.options
#       ['pewter']
#     end
#   end
end
