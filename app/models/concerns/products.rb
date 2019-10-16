require 'active_support/concern'

module Products
  extend ActiveSupport::Concern

  class_methods do
    def pop_products
      existing_set = existing_products
      if existing_set.any?
        create_missing(existing_set)
      else
        create_all
      end
    end

    def product_set
      product_groups =[]
      media = Element.by_kind('medium')
      materials = Element.by_kind('material')
      ElementSet::Medium.set.each do |media_set|
        media_group = media_set.map {|medium_name| media.where(name: medium_name).first}
        material_set = production_materials(media_set)
        material_group = materials.where(name: material_set)
        material_group.map {|material| product_groups << [media_group, material].flatten}
      end
      product_groups
    end

    def production_materials(name_set)
      if include_any?(name_set, %w[painting mixed-media print]) && name_set.exclude?('hand-pulled')
        %w[canvas paper board metal]
      elsif include_all?(%w[production drawing], name_set)
        'animation-paper'
      elsif name_set.include?('drawing') && name_set.exclude?('production')
        'drawing-paper'
      elsif name_set.include?('hand-pulled')
        'canvas'
      elsif name_set.include?('photography')
        'photography-paper'
      elsif name_set.include?('sericel')
        'sericel'
      elsif name_set.include?('hand-blown')
        'glass'
      elsif name_set.include?('hand-made')
        'ceramic'
      elsif name_set.include?('sculpture')
        %w[glass ceramic metal synthetic]
      end
    end

    def existing_products
      existing_set =[]
      Element.by_kind('product').each do |product|
        product_group = product.elements #where(kind: %w[medium material])
        update_product_tags(product, build_product_tags(product_group.map(&:name)))
        existing_set << product_group if product_group.any?
      end
      existing_set
    end

    def create_missing(existing_set)
      product_set.each do |target_set|
        if existing_set.exclude?(target_set)
          build_product(target_set)
        end
      end
    end

    def create_all
      product_set.each do |target_set|
        build_product(target_set)
      end
    end

    def build_product(target_set)
      name = format_product_name(target_set.map(&:name))
      product = find_or_create_by(kind: 'product', name: name)
      update_product_tags(product, build_product_tags(target_set.map(&:name)))
      target_set.map {|target| assoc_unless_included(origin: product, target: target)}
    end

    def format_product_name(name_set)
      if idx = name_set.index('sculpture')
        name_set[0..-2].insert(idx, name_set[-1]).join(' ')
      elsif name_set[-1] == 'sericel'
        name_set[0..-2].join(' ')
      else
        name_set.insert(-2, 'on').join(' ')
      end
    end

    ################################################################ tags part 1

    def build_product_tags(name_set)
      tag_hsh ={}
      product_boolean_tag(name_set, tag_hsh)
      product_attr_tags(name_set, tag_hsh)
      tag_hsh
    end

    def product_boolean_tag(name_set, tag_hsh)
      name_set.each do |name|
        tag_hsh.merge!(h={"#{name}" => "true"}) if boolean_tag_options.include?(name)
      end
      tag_hsh
    end

    def boolean_tag_options
      ElementKind::Medium::BooleanTag.new.primary + ElementKind::Medium::BooleanTag.new.category
    end
    #  => ["painting", "drawing", "mixed-media", "print", "sericel", "photography", "sculpture", "hand-blown", "hand-made", "original", "one-of-a-kind", "production", "limited-edition", "hand-pulled"]

    ################################################################ tags part 2

    #product_attr_tags
    def product_attr_tags(name_set, tag_hsh)
      if include_any?(name_set, %w[original one-of-a-kind])
        tag_hsh.merge!(h={'art_type' => "original", "art_category" => "original-painting"})
      elsif name_set.include?('limited-edition') && include_any?(name_set, %w[print sericel photography])
        tag_hsh.merge!(h={'art_type' => "limited-edition", "art_category" => "limited-edition"})
      elsif name_set.exclude?('limited-edition') && include_any?(name_set, %w[print sericel photography])
        tag_hsh.merge!(h={'art_type' => "print", "art_category" => "limited-edition"})
      elsif include_any?(name_set, %w[sculpture hand-made])
        tag_hsh.merge!(h={'art_type' => "sculpture", "art_category" => "sculpture"})
      elsif name_set.include?('hand-blown')
        tag_hsh.merge!(h={'art_type' => "sculpture", "art_category" => "hand-blown-glass"})
      end
    end

    ################################################################ tags part 3

    def format_text_value(tag_set)
      if tag_set.is_a? Array
        text_value = tag_set.join(' ')
        include_any?(tag_set, %w[animation photography]) ? text_value : text_value.pluralize
      else
        tag_set == 'hand-blown-glass' ? tag_set : tag_set.pluralize
      end
    end

    def format_scope_value(tag_set)
      if tag_set.is_a? Array
        to_snake(tag_set.join('_')).to_sym
      else
        to_snake(tag_set).to_sym
      end
    end

    ################################################################ search value list

    def product_search_dropdown_vl
      [
        ['all products', 'products'],
        ['original paintings', 'painting'],
        ['one-of-a_kind mixed-media', 'one_of_a_kind_mixed_media'],
        ['one-of-a_kind mixed-media numbered 1/1', 'single_edition_one_of_a_kind_mixed_media'],
        ['production art', 'production'],
        ['drawings', 'drawing'],
        ['limited edition prints', 'limited_edition_prints'],
        ['hand-pulled prints', 'hand_pulled'],
        ['photography', 'photography'],
        ['prints', 'only_prints'],
        ['sericels', 'sericel'],
        ['hand-blown glass', 'hand_blown'],
        ['hand-made ceramic', 'hand_made'],
        ['sculptures', 'standard_sculptures'],
        ['limited edition sculptures', 'limited_edition_sculptures']
      ]
    end

    # def compound_tags_vl
    #   compound_search_tags.map {|tag_set| [format_text_value(tag_set), format_scope_value(tag_set)]}
    # end
    #
    # def hash_tags_vl
    #   hash_search_tags.map {|tag| [format_text_value(tag), format_scope_value(tag)]}
    # end
    #
    # def compound_search_tags
    #   [%w[original painting], %w[production], %w[one-of-a-kind mixed-media], %w[original drawing], %w[hand-pulled print], %w[photography], %w[mixed-media], %w[sericel]]
    # end
    #
    # def hash_search_tags
    #   %w[limited-edition print hand-blown-glass]
    # end
  end
end
