module Embellished
  extend BuildSet
  extend ProductBuild

  def self.populate
    embellish = find_or_create_by(kind: 'embellishment', name: element_name(self)) #=> "embellished"
    konstant = to_scoped_constant(FlatProduct::PrintMedium::Medium)             #=> FlatProduct::PrintMedium::Medium
    konstant.constants.reject {|klass| [:Sericel, :Photograph].include?(klass)}.each do |klass|    #=> [:StandardPrint, :HandPulled, :Sericel, :Photograph]
      ['limited edition', nil].each do |category|
        category = find_or_create_by(kind: 'medium', name: element_name(category)) if category.present?
        medium = find_or_create_by(kind: 'medium', name: element_name(klass))
        to_scoped_constant(konstant, klass).new.sub_medium.each do |sub_medium_name|
          sub_medium = find_or_create_by(kind: 'sub_medium', name: element_name(sub_medium_name))
          if material_set = to_scoped_constant(konstant, klass).new.material.detect {|set| set.first.include?(sub_medium_name)}
            material_set.last.map {|material_name| find_or_create_by(kind: 'material', name: material_name)}.each do |material|
              build_product([embellish, category, sub_medium, medium, material].compact)
            end
          else
            build_product([embellish, category, sub_medium, medium])
          end
        end
      end
    end
  end
end

#FlatProduct::OneOfAKind::Medium::MixedMedium.new.sub_medium
# %w[one-of-a-kind mixed-media single-edition],
# %w[one-of-a-kind hand-pulled-silkscreen single-edition],
#
# %w[hand-pulled-silkscreen single-edition],
# %w[embellished one-of-a-kind mixed-media single-edition],
# %w[embellished one-of-a-kind hand-pulled-silkscreen single-edition]
