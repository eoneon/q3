module LimitedEdition
  extend BuildSet
  extend ProductBuild

  def self.populate
    category = find_or_create_by(kind: 'category', name: FlatProduct.element_name(self)) #=> "limited edition"
    konstant = to_scoped_constant(FlatProduct::PrintMedium::Medium)             #=> FlatProduct::PrintMedium::Medium
    konstant.constants.reject {|klass| klass == :BasicPrint}.each do |klass|    #=> [:StandardPrint, :HandPulled, :Sericel, :Photograph]
      medium = find_or_create_by(kind: 'medium', name: element_name(klass))
      to_scoped_constant(konstant, klass).new.sub_medium.each do |sub_medium_name|
        sub_medium = find_or_create_by(kind: 'sub_medium', name: element_name(sub_medium_name))
        if material_set = to_scoped_constant(konstant, klass).new.material.detect {|set| set.first.include?(sub_medium_name)}
          material_set.last.map {|material_name| find_or_create_by(kind: 'material', name: material_name)}.each do |material|
            build_product([category, sub_medium, medium, material])
          end
        else
          build_product([category, sub_medium, medium])
        end
      end
    end
  end

  def self.test

  end
end
