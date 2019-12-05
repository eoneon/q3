module ProductType
  extend BuildSet
  extend ProductBuild
  #set = ProductType.populate  set.map {|obj_set| obj_set[:product_name]}
  #ProductType.opt_loop

  def self.populate
    build_set = build_hsh
    self.constants.each do |category_module|
      scope_hsh = {medium_module: to_scoped_constant(self, category_module, :medium)}
      scope_hsh[:medium_module].constants.each do |medium_class|
        scope_hsh[:medium_class] = to_scoped_constant(scope_hsh[:medium_module], medium_class)

        product_hsh = build_product_hsh(category_module, medium_class, scope_hsh)
        scope_hsh[:medium_class].new.sub_medium.each do |sub_medium_name|
          product_hsh[:sub_medium] = find_or_create_by(kind: 'sub-medium', name: format_attr(sub_medium_name,4))
          product_hsh[:materials] = scope_hsh[:medium_class].new.material.detect {|set| set.first.include?(sub_medium_name)}.last.map {|material_name| find_or_create_by(kind: 'material', name: material_name)}
          build_product_params(scope_hsh, product_hsh, materials, build_set)
        end
      end
    end
    build_set
  end
  #12:
  def self.build_product_hsh(category_module, medium_class, scope_hsh)
    product_hsh = {
      category: find_or_create_by(kind: 'category', name: format_attr(category_module,4)),
      medium: find_or_create_by(kind: 'medium', name: format_attr(medium_class,4))
      #mounting_dimension: find_or_create_by(kind: 'mounting-dimension', name: set_mounting_dimension(format_attr(category_module)))
      #options: nil
    }
  end
  #19:
  def self.build_product_params(scope_hsh, product_hsh, materials, build_set)
    materials.each do |material|
      product_hsh[:material] = material
      if scope_hsh[:medium_class].instance_methods(false).include?('sculpture_type')
        add_sculpture_type(scope_hsh, product_hsh, build_set)
      else
        pass_options(scope_hsh, product_hsh, build_set)
      end
    end
    build_set
  end
  #40:
  def self.add_sculpture_type(scope_hsh, product_hsh, build_set)
    scope_hsh[:medium_class].new.sculpture_type.each do |sculpture_type_name|
      product_hsh[:sculpture_type] = find_or_create_by(kind: 'sculpture-type', name: format_attr(sculpture_type_name,4))
      pass_options(scope_hsh, product_hsh, build_set)
    end
    build_set
  end

  def self.pass_options(scope_hsh, product_hsh, build_set)
    #puts "product_hsh ok: #{product_hsh}"
    option_keys = scope_hsh[:medium_class].instance_methods(false).select {|instance_method| [:embellished, :limited_edition, :single_edition].include?(instance_method)}

    product_hsh = build_options(product_hsh, option_keys)
    product_hsh[:options].keys do |option|
      build_set[option] << set_product_params(scope_hsh, product_hsh[:options][option]) unless product_hsh[:options][option].nil? #issue: product_hsh[option_key] not a hsh; not sure how to insert values only
    end
    build_set
  end

  #57:
  def self.build_options(product_hsh, option_keys)
    #puts "70: product_hsh: #{product_hsh}"
    #puts "71: product_hsh: #{product_hsh[:options]}"
    product_hsh[:options] = build_hsh.keys.map {|k| [k, nil]}.to_h
    #puts "73: product_hsh: #{product_hsh[:options]}"
    product_hsh[:options][:standard_products] = product_hsh
    #puts "#{product_hsh[:options][:standard_products]}"
    product_hsh[:options][:embellished_products] = product_hsh.merge(h = {embellished: sub_categories[:embellished]}) if include_all?(option_keys, [:embellished])
    product_hsh[:options][:limited_edition_products] = product_hsh.merge(h = {limited_edition: sub_categories[:limited_edition]}) if include_all?(option_keys, [:limited_edition])
    product_hsh[:options][:single_edition_products] = product_hsh.merge(h = {single_edition: sub_categories[:single_edition]}) if include_all?(option_keys, [:single_edition])

    product_hsh[:options][:embellished_limited_edition_products] = product_hsh.merge(h = {embellished: sub_categories[:embellished], limited_edition: sub_categories[:limited_edition]}) if include_all?(option_keys, [:embellished, :limited_edition])
    product_hsh[:options][:embellished_single_edition_products] = product_hsh.merge(h = {embellished: sub_categories[:embellished], limited_edition: sub_categories[:single_edition]}) if include_all?(option_keys, [:embellished, :single_edition])
    product_hsh
  end
  #59:
  def self.set_product_params(scope_hsh, product_option_hsh)
    product_set = product_option_hsh.values
    product_tags = product_set.map {|obj| [:"#{obj.kind}", obj.name]}.to_h
    product_tags[:assoc_pairs] = format_assoc_pairs(product_set)
    product_name = format_product_name(scope_hsh[:medium_class].new.element_order.map {|k| product_option_hsh[k]}.compact)
    #puts "#{product_name}"
    h = {product_set: product_set, product_name: product_name, product_tags: product_tags}
  end

  def self.format_product_name(product_set)
    name_set =[]
    product_set.each do |obj|
      if name = format_name_set(obj.kind, obj.name)
        name_set << name
      end
    end
    name_set.uniq.compact.join(' ')
  end

  def self.format_name_set(kind, name)
    case
    when kind == 'category' then format_category_name(name)
    when kind == 'medium' then format_medium_name(name)
    when ['sub-medium', 'sculpture-type'].include?(kind) then name
    when kind == 'material' then format_material_name(name)
    when kind == 'single-edition' then 'numbered 1/1'
    end
  end

  def self.format_category_name(name)
    name if ['print medium', 'sculpture'].exclude?(name)
  end

  def self.format_medium_name(name)
    name if ['basic print', 'standard print', 'mixed medium'].exclude?(name)
  end

  def self.format_material_name(name)
    if Material.on_material.include?(name)
      ['on', name].join(' ')
    else
      name
    end
  end

  def self.format_assoc_pairs(product_set)
    product_set.map {|obj| [obj.name, obj.id]}.flatten.join(',')
  end

  def self.set_mounting_dimension(category)
    if category == 'sculpture'
      'two-d'
    else
      'three-d'
    end
  end

  def self.build_hsh
    option_set = [:standard_products, :embellished_products, :limited_edition_products, :single_edition_products, :embellished_limited_edition_products, :embellished_single_edition_products]
    option_set.map {|opt| [opt, a =[]]}.to_h
  end

  def self.sub_categories
    h={limited_edition: find_or_create_by(kind: 'limited-edition', name: 'limited edition'), embellished: find_or_create_by(kind: 'embellished', name: 'embellished'), single_edition: find_or_create_by(kind: 'single-edition', name: 'numbered 1/1')}
  end

  #converts formatted hstore field containing comma delimited list of keys and values into a hsh, which can be used to query db for unique products existence
  def self.assoc_hsh(assoc_list)
    assoc_arr, even, odd = assoc_list.split(','), [], []
    assoc_arr.each do |i|
      if assoc_arr.index(i).even?
        even << i
      else
        odd << i
      end
    end
    [even, odd].transpose.to_h
  end

  def self.combine_option_sets(options)
    combo_set = nil
    options.each do |option|
      if combo_set.nil?
        combo_set = option.map {|opt| [opt]}
      else
        combo_set = combo_set.map {|opt_arr| option.map {|opt2| opt_arr[0..-1] << opt2}}.flatten(1)
      end
    end
    combo_set
  end

  ##############################################################################

  module Original

    module Medium

      class Painting

        def sub_medium
          ['painting', 'oil', 'acrylic', 'mixed media', 'watercolor', 'pastel', 'guache', 'sumi ink']
        end

        def material
          [
            [['watercolor', 'pastel', 'guache', 'sumi ink'], ['paper']],
            [['painting', 'oil', 'acrylic', 'mixed media'], Material.standard_flat]
          ]
        end

        def element_order
          Original::ProductName.element_order
        end
      end

      class Drawing
        #exclude sub_medium if == 'drawing'
        def sub_medium
          ['drawing', 'pen and ink', 'pencil']
        end

        def material
          [
            [Drawing.new.sub_medium, ['paper']]
          ]
        end

        def element_order
          Original::ProductName.element_order
        end
      end

      class Production
        #exclude class
        def sub_medium
          ['production drawing', 'production sericel', 'hand painted production sericel']
        end

        def material
          [
            [['production drawing'], ['animation paper']],
            [['production sericel'], ['sericel']],
            [['hand painted production sericel'], ['sericel']]
          ]
        end

        def element_order
          Original::ProductName.element_order
        end
      end
    end

    module ProductName
      def self.element_order
        [:embellished, :category, :sub_medium, :medium, :material, :single_edition]
      end
    end
  end

  module OneOfAKind
    module Medium

      class MixedMedium
        def sub_medium
          ['mixed media', 'acrylic mixed media', 'mixed media overpaint', 'monoprint']
        end

        def material
          [
            [MixedMedium.new.sub_medium, Material.standard_flat]
          ]
        end

        def embellished
        end

        def element_order
          Original::ProductName.element_order
        end
      end

      class Etching
        def sub_medium
          ['etching']
        end

        def material
          [
            [Etching.new.sub_medium, ['paper']]
          ]
        end

        def limited_edition
        end

        def embellished
        end

        def element_order
          Original::ProductName.element_order
        end
      end

      class HandPulled
        def sub_medium
          ['silkscreen']
        end

        def material
          [
            [['silkscreen'], ['canvas']]
          ]
        end

        def limited_edition
        end

        def embellished
        end

        def single_edition
          HandPulled.new.sub_medium
        end

        def element_order
          [:limited_edition, :embellished, :category, :medium, :sub_medium,  :material, :single_edition]
        end
      end

    end
  end

  module PrintMedium
    module Medium

      class BasicPrint
        def sub_medium
          ['print', 'fine art print', 'vintage style print', 'poster', 'vintage poster']
        end

        def material
          [
            [['print', 'fine art print', 'vintage style print'], Material.standard_flat],
            [['poster', 'vintage poster'], ['paper']]
          ]
        end

        def element_order
          [:sub_medium, :material]
        end
      end

      class StandardPrint
        def sub_medium
          ['giclee', 'serigraph', 'etching', 'lithograph', 'mixed media']
        end

        def material
          [
            [['giclee', 'serigraph', 'mixed media'], Material.standard_flat],
            [['lithograph', 'etching'], ['paper']]
          ]
        end

        def limited_edition
        end

        def embellished
        end

        def element_order
          [:limited_edition, :embellished, :sub_medium,  :material]
        end
      end

      class HandPulled
        def sub_medium
          ['silkscreen', 'lithograph']
        end

        def material
          [
            [['silkscreen'], ['canvas']],
            [['lithograph'], ['paper']]
          ]
        end

        def limited_edition
        end

        def embellished
        end

        def element_order
          [:limited_edition, :embellished, :medium, :sub_medium, :material]
        end
      end

      class Sericel
        def sub_medium
          ['sericel']
        end

        def material
          [
            [['sericel'], ['sericel']]
          ]
        end

        def limited_edition
        end

        def element_order
          [:limited_edition, :sub_medium, :material]
        end
      end

      class Photograph
        def sub_medium
          ['photograph', 'archival photograph', 'single exposure photograph']
        end

        def material
          [
            [Photograph.new.sub_medium, ['photography paper']]
          ]
        end

        def limited_edition
        end

        def element_order
          [:limited_edition, :sub_medium, :material]
        end
      end
    end
  end

  module Sculpture

    module Medium

      class HandBlown
        def sub_medium
          ['hand blown']
        end

        def material
          [
            [HandBlown.new.sub_medium, ['glass']]
          ]
        end

        def sculpture_type
          ['sculpture', 'vase', 'flat vase', 'bowl', 'jar', 'pumpkin', 'heart']
        end

        def element_order
          [:sub_medium, :material, :sculpture_type]
        end
      end

      class HandMade
        def sub_medium
          ['hand made']
        end

        def material
          [
            [HandMade.new.sub_medium, ['ceramic']]
          ]
        end

        def sculpture_type
          ['sculpture', 'vase', 'bowl', 'plate', 'decorative plate', 'jar', 'jar with lid']
        end

        def element_order
          [:sub_medium, :material, :sculpture_type]
        end
      end

      class Sculpture
        def sub_medium
          ['sculpture']
        end

        def material
          [
            [Sculpture.new.sub_medium, ['glass', 'ceramic', 'bronze', 'acrylic', 'pewter', 'lucite', 'mixed media']]
          ]
        end

        def limited_edition
        end

        def embellished
        end

        def element_order
          [:embellished, :limited_edition, :material, :sub_medium, :sculpture_type]
        end
      end
    end
  end

  # module LimitedEdition
  #
  #   module Medium
  #
  #     class StandardPrint < ProductType::PrintMedium::Medium::StandardPrint
  #       def element_order
  #         [:limited_edition, :sub_medium, :material]
  #       end
  #     end
  #
  #     class HandPulled < ProductType::PrintMedium::Medium::HandPulled
  #       def element_order
  #         [:limited_edition, :sub_medium, :material]
  #       end
  #     end
  #
  #     class Sericel < ProductType::PrintMedium::Medium::Sericel
  #       def element_order
  #         #StandardPrint.new.element_order.prepend(:limited_edition)
  #         [:limited_edition, :sub_medium, :material]
  #       end
  #     end
  #
  #     class Photograph < ProductType::PrintMedium::Medium::Photograph
  #       def element_order
  #         [:limited_edition, :medium, :sub_medium, :material]
  #       end
  #     end
  #
  #     class Sculpture < ProductType::Sculpture::Medium::Sculpture
  #       def element_order
  #         [:material, :sub_medium, :sculpture_type]
  #       end
  #     end
  #   end
  # end


end
