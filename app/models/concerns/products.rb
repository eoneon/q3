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
      product_groups, media =[], Element.by_kind('medium')
      ElementKind::Medium::TextTag.new.material_type.map{|set| set.first}.each do |material_type|
        media.primary_media.where("tags @> ?", ("material_type => #{material_type}")).each do |medium|
          ElementSet::Medium.set.each do |set|
            if set.include?(medium.name)
              media_group = media.where(name: set)
              scoped_materials = Element.by_kind('material').where("tags @> ?", ("#{material_type} => true"))
              scoped_materials.map {|material| product_groups << [media_group, material].flatten}
            end
          end
        end
      end
      product_groups
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
      target_set.map {|target| assoc_unless_included(origin: product, target: target)}
    end

    def format_product_name(name_set)
      if idx = name_set.index('sculpture')
        name_set[0..-2].insert(idx, name_set[-1]).join(' ')
      else
        name_set.insert(-2, 'on').join(' ')
      end
    end

    ################################################################ tags part 1

    def build_product_tags(name_set)
      tag_hsh ={}
      product_boolean_tag(name_set, tag_hsh)
      product_attr_tags(name_set, tag_hsh)
      product_search_tags(name_set, tag_hsh)
      tag_hsh
    end

    def product_boolean_tag(name_set, tag_hsh)
      name_set.each do |name|
        tag_hsh.merge!(h={"#{name}" => "true"}) if boolean_tag_options.include?(name)
      end
      tag_hsh
    end

    def boolean_tag_options
      ElementKind::Medium::BooleanTag.new.primary + %w[original one-of-a-kind production limited-edition hand-pulled]
    end

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

    def product_search_tags(name_set, tag_hsh)
      #if tags = compound_search_tags.detect {|tag_set| include_all?(name_set, tag_set)}
      if tags = compound_search_tags.detect {|tag_set| include_all?(tag_set, name_set)}
        tag_hsh.merge!(h={'search_scope' => format_text_value(tags)})
      elsif ['print', 'sculpture', 'hand-blown-glass'].include?(tag_hsh["art_type"])
        tag_hsh.merge!(h={'search_scope' => format_text_value( tag_hsh["art_type"] )})
      end
    end

    # def set_search_value(name_set, art_type)
    #   if tag_set = compound_search_tags.detect {|tag_set| include_all?(name_set, tag_set)}
    #     format_text_value(tag_set)
    #   elsif ['print', 'sculpture', 'hand-blown-glass'].include?(art_type) #detect {|tag| tag_hsh["art_type"] = tag}
    #     #format_text_value(art_type)
    #     art_type
    #   end
    # end

    def format_text_value(tag_set)
      if tag_set.is_a? Array
        text_value = tag_set.join(' ')
        include_any?(tag_set, %w[animation photography] ) ? text_value : text_value.pluralize
      else
        tag_set == 'hand-blown-glass' ? tag_set : tag_set.pluralize
      end
    end

    # def format_scope_value(tag_set)
    #   if tag_set.is_a? Array
    #     to_snake(tag_set.join('_')).to_sym
    #   else
    #     to_snake(tag_set).to_sym
    #   end
    # end

    ################################################################ search value list

    def product_search_dropdown_vl
      compound_tags_vl + hash_tags_vl
    end

    def compound_tags_vl
      compound_search_tags.map {|tag_set| [format_text_value(tag_set), format_scope_value(tag_set)]}
    end

    def hash_tags_vl
      hash_search_tags.map {|tag| [format_text_value(tag), format_scope_value(tag)]}
    end

    def compound_search_tags
      [%w[original painting], %w[production animation], %w[one-of-a-kind mixed-media], %w[original drawing], %w[hand-pulled print], %w[photography], %w[mixed-media], %w[sericel]]
    end

    def hash_search_tags
      %w[limited-edition print hand-blown-glass]
    end
  end
end
