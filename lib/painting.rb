module Painting
  extend BuildSet

  def self.populate
    original = find_or_create_by(kind: 'medium', name: 'original')
    painting = find_or_create_by(kind: 'medium', name: 'painting')
    Medium::BooleanTag.new.paint_media.each do |paint_name|
      paint_medium = find_or_create_by(kind: 'medium', name: paint_name)
      build_material_set(paint_name).each do |material_name|
        obj_set = [original, paint_medium, painting, find_or_create_by(kind: 'material', name: material_name)]
        name = obj_set.map(&:name).insert(-2, 'on').join(' ')
        product = find_or_create_by(kind: 'product', name: name)
        update_tags(product, set_tags(obj_set.map(&:name)))
        obj_set.map {|target| assoc_unless_included(origin: product, target: target)}
      end
    end
  end

  def self.set_tags(names, tags={})
    names.map {|name| tags.merge!(h={name => 'true'})}
    tags
  end

  def self.build_material_set(medium)
    if Medium::BooleanTag.new.canvas_only.include?(medium)
      %w[canvas]
    elsif Medium::BooleanTag.new.paper_only.include?(medium)
      %w[paper]
    elsif Medium::BooleanTag.new.standard_flat_material.include?(medium)
      Material::BooleanTag.new.standard_flat
    end
  end
end
