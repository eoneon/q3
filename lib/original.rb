module Original
  extend BuildSet

  def self.populate
    category = find_or_create_by(kind: 'medium', name: to_snake(self.to_s).split('_').join('-'))
    medium_names.each do |medium_name, sub_medium_names|
      medium = find_or_create_by(kind: 'medium', name: medium_name)
      #if sub_medium_names...
      sub_medium_names.each do |sub_medium_name|
        sub_medium = find_or_create_by(kind: 'medium', name: sub_medium_name)

        if material_options(sub_medium.name).present?
          build_material_set(category, sub_medium, medium)
        else
          product_set = [category, sub_medium, medium]

          name = format_name(product_set.map(&:name))
          product = find_or_create_by(kind: 'product', name: name)
          update_tags(product, set_tags(product_set.map(&:name)))
          product_set.map {|target| assoc_unless_included(origin: product, target: target)}
        end

      end
    end
  end

  def self.build_material_set(category, sub_medium, medium)
    material_options(sub_medium.name).each do |material_name|
      product_set = [category, sub_medium, medium, find_or_create_by(kind: 'material', name: material_name)]
      name = format_name(product_set.map(&:name))
      product = find_or_create_by(kind: 'product', name: name)
      update_tags(product, set_tags(product_set.map(&:name)))
      product_set.map {|target| assoc_unless_included(origin: product, target: target)}
    end
  end

  def self.medium_names
    h={
      'painting' => painting_media, 'drawing' => drawing_media, 'production' => production_media,
      'mixed-media' => mixed_media,
      'basic-print' => basic_print_media, 'standard-print' => standard_print_media, 'hand-pulled-print' => hand_pulled_print_media,
    }
  end

  def self.painting_media
    ['painting', 'oil', 'acrylic', 'watercolor', 'mixed media', 'pastel', 'guache', 'sumi ink']
  end

  def self.drawing_media
    ['drawing', 'pen and ink', 'pencil']
  end

  def self.production_media
    ['production drawing', 'hand painted production sericel', 'production sericel']
  end

  def self.mixed_media
    ['mixed-media', 'acrylic mixed media', 'mixed media overpaint']
  end

  def self.basic_print_media
    ['print', 'find art print', 'vintage style print', 'poster', 'vintage poster']
  end

  def self.standard_print_media
    ['giclee', 'serigraph', 'etching', 'lithograph', 'mixed media']
  end

  def self.hand_pulled_print_media
    ['silkscreen', 'lithograph']
  end

  ##############################################################################

  # def self.on_material
  #   Material::BooleanTag.new.standard_flat | Material::BooleanTag.new.photography_paper | Material::BooleanTag.new.production_drawing_paper
  # end

  def self.material_options(medium)
    if paper_only.include?(medium)
      %w[paper]
    elsif standard_flat_medium.include?(medium)
      Material.standard_flat
    elsif medium == 'production drawing'
      ['animation paper']
    elsif medium == 'photography'
      ['photography paper']
    end
  end

  def self.paper_only
    ['watercolor', 'pastel', 'guache', 'sumi ink', 'etching', 'lithograph', 'poster', 'vintage poster'] + drawing_media
  end

  def self.canvas_only
    ['silkscreen']
  end

  def self.standard_flat_medium
    ['painting', 'oil', 'acrylic', 'mixed media', 'giclee', 'serigraph', 'mixed media print']
  end

  ##############################################################################

  def self.format_name(name_set, set=[])
    name_set.insert(-2, 'on') if Material.on_material.include?(name_set.last)
    name_set.join(' ').split(' ').each do |name|
      set << name if set.exclude?(name)
    end
    set.join(' ')
  end

  ##############################################################################

  def self.set_tags(names, tags={})
    names.map {|name| tags.merge!(h={name => 'true'})}
    tags
  end
end
