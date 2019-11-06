module OptionGroupSet
  extend BuildSet
  extend ProductBuild

  def self.populate
    self.constants.each do |mojule|
      opt_grp_set = find_or_create_by(kind: format_attr(self), name: format_opt_name(mojule, self))                  #Element(kind: 'option-group-set', name: 'element-option-group-set')
      to_scoped_constant(self, mojule).build_option_group(opt_grp_set)
    end
  end

  ##############################################################################

  module Edition
    extend BuildSet

    def self.build_option_group(opt_grp_set)
      OptionGroup.set.each do |opt_grp_name|                                                                         #['numbered x/y', 'numbered qty', 'proof']
        opt_grp = find_or_create_by(kind: 'option-group', name: OptionGroup.format_name(opt_grp_name))               #Element(kind: 'option-group', name: 'numbered x/y'),...
        opt_grp = build_proof_options(build_standard_edition(opt_grp))
        assoc_unless_included(origin: opt_grp_set, target: opt_grp)
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
end
