module OptionGroupSet
  extend BuildSet
  extend ProductBuild

  def self.populate
    self.constants.each do |mojule|
      opt_grp_set = build_opt_grp(format_attr(self), format_opt_name(mojule, self), h={"option_type" => to_snake(mojule)}) #Element(kind: 'option-group-set', name: 'element-option-group-set')
      to_scoped_constant(self, mojule).build_option_group(opt_grp_set)
    end
  end

  def self.build_opt_grp(kind, name, tags)                                                                                 #product_set = [[:category, category], [:sub_medium, sub_medium], [:medium, medium], [:material, material]]
    obj = find_or_create_by(kind: kind, name: name)
    update_tags(obj, tags)
    obj
  end

  ##############################################################################



  ##############################################################################

  module Edition
    extend BuildSet

    def self.build_option_group(opt_grp_set)
      OptionGroup.set.each do |opt_grp_name|                                                                         #['numbered x/y', 'numbered qty', 'proof']
        opt_grp = find_or_create_by(kind: 'option-group', name: OptionGroup.format_name(opt_grp_name))               #Element(kind: 'option-group', name: 'numbered x/y'),...
        opt_grp = build_proof_options(build_standard_edition(opt_grp))
        assoc_unless_included(origin: opt_grp_set, target: opt_grp)
        limited_edition = find_or_create_by(kind: 'category', name: 'limited edition')
        assoc_unless_included(origin: limited_edition, target: opt_grp_set)
      end
    end

    def self.build_standard_edition(opt_grp)
      if opt_grp.name.split(' ').exclude?('proof')
        option = find_or_create_by(kind: 'option', name: opt_grp.name)                                               #Element(kind: 'option', name: 'numbered x/y'), Element(kind: 'option', name: 'numbered qty'),...
        edition_set = opt_grp.name.split(' ').map {|edition| find_or_create_by(kind: 'edition', name: edition)}      #[Element(kind: 'edition', name: 'numbered'), Element(kind: 'edition', name: 'x/y')]
        edition_set.map {|edition| assoc_unless_included(origin: option, target: edition)}                           #opt_grp.elements << edition_set
        assoc_unless_included(origin: opt_grp, target: option)
      end
      opt_grp
    end

    def self.build_proof_options(opt_grp)                                                                            #Element(kind: 'option-group', name: 'numbered x/y')
      proof_set = Option.set.map {|proof| find_or_create_by(kind: 'edition', name: proof)}                           #[Element(kind: 'edition', name: 'AP'),...]
      proof_set.each do |proof|
        name_set = opt_grp.name.split(' ').prepend(proof.name).reject {|i| i == 'proof' || i == 'edition'}
        option = find_or_create_by(kind: 'option', name: Option.format_name(name_set))                               #Element(kind: 'option', name: 'AP numbered x/y')
        name_set.map {|edition_name| find_or_create_by(kind: 'edition', name: edition_name)}.map {|edition| assoc_unless_included(origin: option, target: edition)}
        assoc_unless_included(origin: opt_grp, target: option)                                                       #opt_grp.elements << option
      end
      opt_grp
    end

    class OptionGroup
      def self.set
        ['numbered x/y', 'numbered qty', 'proof']
      end

      def self.format_name(opt_grp_name) #string
        if opt_grp_name == 'proof'
          opt_grp_name + ' ' + 'edition'
        else
          opt_grp_name
        end
      end
    end

    class Option
      def self.set
        %w[AP EA CP GP PP IP HC TC]
      end

      def self.format_name(name_set) #arr
        name = name_set.join(' ')
        if set.include?(name)
          ['from', OptionGroupSet.format_vowel('a', name), name, 'edition'].join(' ')
        else
          name
        end
      end
    end

  end

  module Dimension
    extend BuildSet

    def self.build_option_group(opt_grp_set)
      OptionGroup.set.each do |opt_grp_name|
        opt_grp = find_or_create_by(kind: 'option-group', name: opt_grp_name) #'flat dimension'
        dimension_set = Option.set.assoc(opt_grp.name).last.map {|dimension_name| find_or_create_by(kind: 'dimension', name: dimension_name)}
        name = arr_to_text(dimension_set.map(&:name))
        option = find_or_create_by(kind: 'option', name: name)
        dimension_set.map {|dimension| assoc_unless_included(origin: option, target: dimension)}
        assoc_unless_included(origin: opt_grp, target: option)
        assoc_unless_included(origin: opt_grp_set, target: opt_grp)
        ###########################################################
        #find_or_create_by(kind: 'material', name: OptionGroupAssoc.set.assoc(opt_grp.name).last).map {|material| assoc_unless_included(origin: material, target: opt_grp)}
      end
    end

    class OptionGroup
      def self.set
        ['flat dimension', 'sculpture dimension']
      end
    end

    class Option
      def self.set
        [
          [OptionGroup.set[0], %w[width height]],
          [OptionGroup.set[1], %w[width height depth]]
        ]
      end
    end

    class OptionGroupAssoc
      def self.set
        [
          [OptionGroup.set[0], Material.flat_dimension_material],
          [OptionGroup.set[1], Material.standard_sculpture]
        ]
      end
    end
  end

  module Mounting
    extend BuildSet

    def self.build_option_group(opt_grp_set)
      OptionGroup.set.each do |opt_grp_name|
        opt_grp = find_or_create_by(kind: 'option-group', name: opt_grp_name)                                        #Element(kind: 'option-group', name: 'flat mounting')
        mounting_set = Option.set.assoc(opt_grp.name).last.map {|mounting_name| find_or_create_by(kind: 'option', name: mounting_name)}
        mounting_set.map {|mounting| assoc_unless_included(origin: opt_grp, target: mounting)}
        assoc_unless_included(origin: opt_grp_set, target: opt_grp)
        find_or_create_by(kind: 'material', name: MaterialAssoc.set.assoc(opt_grp.name).last).map {|material| assoc_unless_included(origin: material, target: opt_grp)}
        #find_or_create_by(kind: 'dimension', name: DimensionAssoc.set.assoc(opt_grp.name).last).map {|dimension| assoc_unless_included(origin: opt_grp, target: dimension)}
      end
    end

    class OptionGroup
      def self.set
        ['flat mounting', 'sculpture mounting', 'canvas mounting']
      end
    end

    class Option
      def self.set
        [
          [OptionGroup.set[0], %w[framed bordered matted wall-mount stand]],
          [OptionGroup.set[1], %w[case base wall-mount]],
          [OptionGroup.set[2], ['stretched', 'gallery wrapped', 'framed', 'bordered', 'matted', 'wall-mount']]
        ]
      end
    end

    # class MaterialAssoc
    #   def self.set
    #     [
    #       [OptionGroup.set[0], Material.flat_dimension_material.reject {|material| material == 'canvas'}],
    #       [OptionGroup.set[1], Material.standard_sculpture],
    #       [OptionGroup.set[2], %w[canvas]]
    #     ]
    #   end
    # end
    #
    # class DimensionAssoc
    #   def self.set
    #     [
    #       [OptionGroup.set[0], %w[width height]],
    #       [OptionGroup.set[1], %w[width height depth]],
    #       [OptionGroup.set[2], %w[width height]]
    #     ]
    #   end
    # end
  end

  module Certificate
    extend BuildSet

    def self.build_option_group(opt_grp_set)
      OptionGroup.set.each do |opt_grp_name|
        opt_grp = find_or_create_by(kind: 'option-group', name: opt_grp_name)                                                                    #Element(kind: 'option-group', name: 'flat mounting')
        certificate_set = Option.set.assoc(opt_grp.name).last.map {|certificate_name| find_or_create_by(kind: 'option', name: certificate_name)}
        certificate_set.map {|certificate| assoc_unless_included(origin: opt_grp, target: certificate)}
        assoc_unless_included(origin: opt_grp_set, target: opt_grp)
        #OptionGroupAssoc
      end
    end

    class OptionGroup
      def self.set
        ['standard certificate', 'publisher certificate']
      end
    end

    class Option
      def self.set
        [
          [OptionGroup.set[0], %w[COA LOA]],
          [OptionGroup.set[1], ['Peter Max COA', 'PSA/DNA']]
        ]
      end
    end
  end

  module Signature
    extend BuildSet

    def self.build_option_group(opt_grp_set)
      OptionGroup.set.each do |opt_grp_arr| #%w[artist]
        signer_type_set = opt_grp_arr.map {|signer_type_name| find_or_create_by(kind: 'signer-type', name: signer_type_name)} #[Element(kind: 'signature', 'artist')],...
        opt_grp = find_or_create_by(kind: 'option-group', name: arr_to_text(opt_grp_arr))
        assoc_set_unless_included(origin: opt_grp, kind: 'signer-type', targets: signer_type_set)
        signature_opt_grp = find_or_create_by(kind: 'option-group', name: 'signature-options')
        signature_type_set = Option.set.map {|signature_type_name| find_or_create_by(kind: 'signature-type', name: signature_type_name)}
        signature_type_set.map {|signature_type| assoc_unless_included(origin: signature_opt_grp, target: signature_type)}
        signer_type_set.map {|signer_type| assoc_unless_included(origin: signer_type, target: signature_opt_grp)}
        assoc_unless_included(origin: opt_grp_set, target: opt_grp)
      end
    end

    class OptionGroup
      def self.set
        [
          %w[artist], %w[artist artist]
        ]
      end
    end

    class Option
      def self.set
        ['hand signed', 'hand signed inverso', 'plate signed', 'authorized signature', 'official signature', 'estate signed']
      end
    end
  end


  module Leafing
    extend BuildSet

    def self.build_option_group(opt_grp_set)
      OptionGroup.set.each do |opt_grp_name|
        opt_grp = find_or_create_by(kind: 'option-group', name: opt_grp_name)
        leafing_set = Option.set.map {|leafing_name| find_or_create_by(kind: 'option', name: leafing_name)}
        leafing_set.map {|leafing| assoc_unless_included(origin: opt_grp, target: leafing)}
        assoc_unless_included(origin: opt_grp_set, target: opt_grp)
      end
    end

    class OptionGroup
      def self.set
        %w[leafing]
      end
    end

    class Option
      def self.set
        ['gold leafing', 'hand laid gold leafing', 'silver leafing', 'hand laid silver leafing']
      end
    end
  end

  module Remarque
    extend BuildSet

    def self.build_option_group(opt_grp_set)
      OptionGroup.set.each do |opt_grp_name|
        opt_grp = find_or_create_by(kind: 'option-group', name: opt_grp_name)
        remarque_set = Option.set.map {|remarque_name| find_or_create_by(kind: 'option', name: remarque_name)}
        remarque_set.map {|remarque| assoc_unless_included(origin: opt_grp, target: remarque)}
        assoc_unless_included(origin: opt_grp_set, target: opt_grp)
      end
    end

    class OptionGroup
      def self.set
        %w[remarque]
      end
    end

    class Option
      def self.set
        ['remarque', 'hand drawn remarque', 'hand drawn remarque inverso']
      end
    end
  end
end
