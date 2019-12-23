module Edition
  extend BuildSet
  extend EditionType
  extend Category
  # Edition.populate
  # Edition::SingleEdition.option_sets


  def self.populate
    self.option_group.each do |edition|
      build_hsh = build_hsh(to_scoped_constant(self, edition))
      element = find_or_create_by(build_hsh[:attr_values])
      build_options(element, build_hsh) if build_hsh.keys.include?(:options)
    end
  end

  def self.build_options(element, build_hsh)
    build_hsh[:options].each do |option_sets|
      option = find_or_create_by_and_assoc(origin: element, kind: build_hsh[:option], name: option_sets.first, tags: tags(build_hsh[:kind], 'option'))
      build_option_sets(element, build_hsh, option_sets[1..-1]) if option_sets.count > 1
    end
  end

  def self.build_option_sets(option, build_hsh, option_set_values)
    option_set_values.each do |option_set|
      option_key = find_or_create_by_and_assoc(origin: option, kind: build_hsh[:option_key], name: option_set.first, tags: tags(build_hsh[:kind], 'option-key'))
      find_or_create_by(kind: build_hsh[:option_value], name: option_set.last, tags: tags(build_hsh[:kind], 'option-value')).each do |option_value|
        assoc_unless_included(origin: option_key, target: option_value)
      end
    end
  end

  def self.tags(kind, option_kind)
    h = {"option_kind" => option_kind, "element_kind" => kind}
  end

  def self.option_group
    self.constants.map {|konstant| konstant}
  end

  # def self.proofs
  #   ['AP', 'EA', 'CP', 'GP', 'PP', 'IP', 'HC', 'TC', 'Japanese']
  # end
  #
  # def self.limited_types
  #   ['limited edition', 'sold out limited edition']
  # end

  ##############################################################################

  class LimitedEdition
    extend Category

    def self.options
      EditionType::LimitedEdition.option_sets
    end
    # def self.options
    #   [
    #     ['numbered xy', [:proofs, :limited_types]],
    #     ['Roman numbered xy', [:proofs, :limited_types]],
    #     ['numbered qty', [:proofs, :limited_types]],
    #     ['proof edition', [:proofs, :limited_types]]
    #   ]
    # end
  end

  # class LimitedEdition
  #   extend Category
  #
  #   def self.options
  #     [
  #       [
  #         'numbered xy', ['proofs', Edition.proof_values], ['limited type', Edition.limited_type_values]
  #       ],
  #
  #       [
  #         'Roman numbered xy', ['proofs', Edition.proof_values], ['limited type', Edition.limited_type_values]
  #       ],
  #
  #       [
  #         'numbered qty', ['proofs', Edition.proof_values], ['limited type', Edition.limited_type_values]
  #       ],
  #
  #       [
  #         'proof edition', ['proofs', Edition.proof_values], ['limited type', Edition.limited_type_values]
  #       ]
  #     ]
  #   end
  # end

  class SingleEdition
    extend Category

    # def self.options
    #   [
    #     [
    #     'proof edition', ['proofs', Edition.proof_values]
    #     ]
    #   ]
    # end

    def self.options
      EditionType::SingleEdition.option_sets
    end
  end

end
