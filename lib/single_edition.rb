module SingleEdition
  extend BuildSet
  extend ProductBuild

  def self.populate
    derivative_hsh = derivative_elements
    self.constants.each do |mojule|                                                                                             #Original, OneOfAKind, PrintMedium
      category = find_or_create_by(kind: 'category', name: element_name(mojule))                                                #Element(kind: 'category', name: 'original'),...
      konstant = to_scoped_constant(self, mojule)                                                                               #FlatProduct::Original, FlatProduct::OneOfAKind, FlatProduct::PrintMedium
      to_scoped_constant(konstant, :medium).constants.each do |klass|                                                           #FlatProduct::Original::Medium => [:Painting, :Drawing, :Production], FlatProduct::OneOfAKind::Medium => [:MixedMedium, :Etching, :HandPulled],...
        medium = find_or_create_by(kind: 'medium', name: element_name(klass))                                                   #Element(kind: 'medium', name: 'painting'),...
        to_scoped_constant(konstant, :medium, klass).new.sub_medium.each do |sub_medium_name|                                   #FlatProduct::Original::Medium.new.sub_medium => ['painting', 'oil', 'acrylic', 'mixed media', 'watercolor', 'pastel', 'guache', 'sumi ink']
          sub_medium = find_or_create_by(kind: 'sub_medium', name: element_name(sub_medium_name))                               #Element(kind: 'sub_medium', name: 'oil'),...
          material_set.last.map {|material_name| find_or_create_by(kind: 'material', name: material_name)}.each do |material|
            build_product([category, sub_medium, medium, material])
            derivative_products(to_scoped_constant(konstant, :medium), derivative_hsh, [category, sub_medium, medium, material])
          end
        end
      end
    end
  end

  def self.derivative_products(konstant, hsh, product_set)
    build_product(product_set.prepend(hsh[:limited_edition])) if konstant.instance_methods(false).include?(:limited_edition)
    build_product(product_set.prepend(hsh[:embellished])) if konstant.instance_methods(false).include?(:embellished)
    build_product(product_set.prepend(hsh[:limited_edition]).prepend(hsh[:limited_edition])) if konstant.instance_methods(false).include_all?(:embellished, :limited_edition)
    build_product(product_set.append(hsh[:single_edition])) if konstant.instance_methods(false).include?(:single_edition) && !(konstant.split('::').include?(StandardPrint) && konstant.instance_methods(false).include?(:embellished))
    end
  end

def self.derivative_elements
  h={
    embellished: find_or_create_by(kind: 'embellishment', name: 'embellished'),
    single_edition: find_or_create_by(kind: 'edition', name: 'single edition'),
    limited_edition: find_or_create_by(kind: 'edition', name: 'limited edition')
  }
end
  # def self.populate
  #   edition = find_or_create_by(kind: 'edition', name: element_name(self))
  #   konstant = to_scoped_constant(FlatProduct::PrintMedium::Medium)
  #   one_of_a_kind_mixed = to_scoped_constant(FlatProduct::OneOfAKind::Medium::MixedMedium)
  #   one_of_a_kind_etching = to_scoped_constant(FlatProduct::OneOfAKind::Medium::Etching)
  #   one_of_a_kind_hand = to_scoped_constant(FlatProduct::OneOfAKind::Medium::HandPulled)
  #   ['embellished', nil].each do |category|
  #     embellished = find_or_create_by(kind: 'embellish', name: element_name(embellished)) if category.present?
  #   end
  # end
end
