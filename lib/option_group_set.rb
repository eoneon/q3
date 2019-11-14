module OptionGroupSet
  extend BuildSet
  extend ProductBuild

  def self.populate
    self.constants.each do |mojule|
      opt_grp_set = create_opt(klass: mojule, name: format_opt_name(mojule, self), idx: 0)
      to_scoped_constant(self, mojule).build_option_group(opt_grp_set)
    end
  end

  def self.create_opt(klass:, name:, idx:)
    option_kind = ['option-group-set', 'option-group', 'option'][idx]                                                                              #product_set = [[:category, category], [:sub_medium, sub_medium], [:medium, medium], [:material, material]]
    obj = find_or_create_by(kind: format_opt_kind(klass, option_kind), name: name)
    update_tags(obj, h={"option_type" => to_snake(klass), "option_kind" => option_kind})
    obj
  end

  def self.format_opt_kind(klass, option_kind)
    [format_attr(klass.to_s.split('::').last), option_kind].join('-')
  end

  ##############################################################################

  module Edition
    extend BuildSet

    def self.build_option_group(opt_grp_set)
      OptionGroup.set.each do |opt_grp_name|
        #['numbered x/y', 'numbered qty', 'proof']
        opt_grp = OptionGroupSet.create_opt(klass: self, name: opt_grp_name, idx: 1) # Element(kind: 'option-group', name: 'numbered x/y'),...
        opt_grp = build_proof_options(build_standard_edition(opt_grp))
        assoc_unless_included(origin: opt_grp_set, target: opt_grp)

        limited_edition = find_or_create_by(kind: 'category', name: 'limited edition')
        assoc_unless_included(origin: limited_edition, target: opt_grp_set)
      end
    end

    def self.build_standard_edition(opt_grp)
      if opt_grp.name.split(' ').exclude?('proof')
        option = OptionGroupSet.create_opt(klass: self, name: opt_grp.name, idx: 2)   #Element(kind: 'option', name: 'numbered x/y'), Element(kind: 'option', name: 'numbered qty'),...
        edition_set = opt_grp.name.split(' ').map {|edition| find_or_create_by(kind: 'edition', name: edition)}      #[Element(kind: 'edition', name: 'numbered'), Element(kind: 'edition', name: 'x/y')]
        edition_set.map {|edition| assoc_unless_included(origin: option, target: edition)}                           #opt_grp.elements << edition_set
        assoc_unless_included(origin: opt_grp, target: option)
      end
      opt_grp
    end

    def self.build_proof_options(opt_grp)                                                                            #Element(kind: 'option-group', name: 'numbered x/y')
      proof_set = Option.set.map {|proof_name| find_or_create_by(kind: 'edition', name: proof_name)}.each do |proof|                           #[Element(kind: 'edition', name: 'AP'),...]
        name_set = opt_grp.name.split(' ').prepend(proof.name).reject {|i| i == 'proof' || i == 'edition'}
        option = OptionGroupSet.create_opt(klass: self, name: Option.format_name(name_set), idx: 2)
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
        opt_grp = OptionGroupSet.create_opt(klass: self, name: opt_grp_name, idx: 1)
        dimension_set = Option.set.assoc(opt_grp.name).last.map {|dimension_name| find_or_create_by(kind: 'dimension', name: dimension_name)}
        option = OptionGroupSet.create_opt(klass: self, name:arr_to_text(dimension_set.map(&:name)), idx: 2)
        dimension_set.map {|dimension| assoc_unless_included(origin: option, target: dimension)}
        assoc_unless_included(origin: opt_grp, target: option)
        assoc_unless_included(origin: opt_grp_set, target: opt_grp)
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
  end

  module Mounting
    extend BuildSet

    def self.build_option_group(opt_grp_set)
      OptionGroup.set.each do |opt_grp_name|
        opt_grp = OptionGroupSet.create_opt(klass: self, name: opt_grp_name, idx: 1)                                       #Element(kind: 'option-group', name: 'flat mounting')
        mounting_set = Option.set.assoc(opt_grp.name).last.map {|mounting_name| OptionGroupSet.create_opt(klass: self, name: mounting_name, idx: 2)}
        mounting_set.map {|mounting| assoc_unless_included(origin: opt_grp, target: mounting)}
        assoc_unless_included(origin: opt_grp_set, target: opt_grp)
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
  end

  module Certificate
    extend BuildSet

    def self.build_option_group(opt_grp_set)
      OptionGroup.set.each do |opt_grp_name|
        opt_grp = OptionGroupSet.create_opt(klass: self, name: opt_grp_name, idx: 1)
        certificate_set = Option.set.assoc(opt_grp.name).last.map {|certificate_name| OptionGroupSet.create_opt(klass: self, name: certificate_name, idx: 2)}                                                                   #Element(kind: 'option-group', name: 'flat mounting')
        certificate_set.map {|certificate| assoc_unless_included(origin: opt_grp, target: certificate)}
        assoc_unless_included(origin: opt_grp_set, target: opt_grp)
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

  # module Signature
  #   extend BuildSet
  #
  #   def self.build_option_group(opt_grp_set)
  #     OptionGroup.set.each do |opt_grp_arr| #%w[artist]
  #       signer_type_set = opt_grp_arr.map {|signer_type_name| find_or_create_by(kind: 'signer-type', name: signer_type_name)} #[Element(kind: 'signature', 'artist')],...
  #       opt_grp = find_or_create_by(kind: 'option-group', name: arr_to_text(opt_grp_arr))
  #       assoc_set_unless_included(origin: opt_grp, kind: 'signer-type', targets: signer_type_set)
  #       signature_opt_grp = find_or_create_by(kind: 'option-group', name: 'signature-options')
  #       signature_type_set = Option.set.map {|signature_type_name| find_or_create_by(kind: 'signature-type', name: signature_type_name)}
  #       signature_type_set.map {|signature_type| assoc_unless_included(origin: signature_opt_grp, target: signature_type)}
  #       signer_type_set.map {|signer_type| assoc_unless_included(origin: signer_type, target: signature_opt_grp)}
  #       assoc_unless_included(origin: opt_grp_set, target: opt_grp)
  #     end
  #   end
  #
  #   class OptionGroup
  #     def self.set
  #       [
  #         %w[artist], %w[artist artist]
  #       ]
  #     end
  #   end
  #
  #   class Option
  #     def self.set
  #       ['hand signed', 'hand signed inverso', 'plate signed', 'authorized signature', 'official signature', 'estate signed']
  #     end
  #   end
  # end


  module Leafing
    extend BuildSet

    def self.build_option_group(opt_grp_set)
      OptionGroup.set.each do |opt_grp_name|
        opt_grp = OptionGroupSet.create_opt(klass: self, name: opt_grp_name, idx: 1)
        leafing_set = Option.set.map {|leafing_name| OptionGroupSet.create_opt(klass: self, name: leafing_name, idx: 2)}
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
        opt_grp = OptionGroupSet.create_opt(klass: self, name: opt_grp_name, idx: 1)
        remarque_set = Option.set.map {|remarque_name| OptionGroupSet.create_opt(klass: self, name: remarque_name, idx: 2)}
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
