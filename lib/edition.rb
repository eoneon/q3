module Edition
  extend BuildSet
  # Edition::LimitedEdition.name
  # Edition.populate

  def self.populate
    self.option_group.each do |edition|
      build_hsh = build_hsh(to_scoped_constant(self, edition))
      element = find_or_create_by(build_hsh[:attr_values])
      build_hsh[:options].each do |option_sets|
        #option = find_or_create_by_and_assoc(origin: element, kind: build_hsh[:option], name: option_sets.first)
        option = find_or_create_by_and_assoc(origin: element, kind: build_hsh[:option], name: option_sets.first, tags: tags(build_hsh[:kind], 'option'))

        #update_tags(option, option_tags(build_hsh[:kind], 'option'))

        option_sets[1..-1].each do |option_set|
          #option_key = find_or_create_by_and_assoc(origin: option, kind: build_hsh[:option_key], name: option_set.first)
          option_key = find_or_create_by_and_assoc(origin: option, kind: build_hsh[:option_key], name: option_set.first, tags: tags(build_hsh[:kind], 'option-key'))
          #update_tags(option_key, option_tags(build_hsh[:kind], 'option-key'))

          find_or_create_by(kind: build_hsh[:option_value], name: option_set.last, tags: tags(build_hsh[:kind], 'option-value')).each do |option_value|
          #find_or_create_by(kind: build_hsh[:option_value], name: option_set.last).each do |option_value|
            #update_tags(option_value, option_tags(build_hsh[:kind], 'option-value'))
            assoc_unless_included(origin: option_key, target: option_value)
          end
        end
      end
    end
  end

  def self.tags(kind, option_kind)
    h = {"option_kind" => option_kind, "element_kind" => kind}
  end

  # def self.option_tags(kind, option_kind)
  #   h = {"option_kind" => option_kind, "element_kind" => kind}
  # end

  def self.option_group
    self.constants.map {|konstant| konstant}
  end

  def self.proof_values
    ['AP', 'EA', 'CP', 'GP', 'PP', 'IP', 'HC', 'TC', 'Japanese']
  end

  def self.limited_type_values
    ['sold out', 'rare', 'vintage']
  end

  ##############################################################################

  class LimitedEdition
    extend Category

    # def self.options
    #   ['numbered xy', 'Roman numbered xy', 'numbered qty', 'proof edition']
    # end

    # def self.sub_options
    #   Edition.proof_types
    # end

    def self.options
      [
        [
          'numbered xy', ['proofs', Edition.proof_values], ['limited type', Edition.limited_type_values]
        ],

        [
          'Roman numbered xy', ['proofs', Edition.proof_values], ['limited type', Edition.limited_type_values]
        ],

        [
          'numbered qty', ['proofs', Edition.proof_values], ['limited type', Edition.limited_type_values]
        ],

        [
          'proof edition', ['proofs', Edition.proof_values], ['limited type', Edition.limited_type_values]
        ]
      ]
    end
  end

  class SingleEdition
    extend Category

    # def self.options
    #   ['single edition']
    # end
    #
    # def self.sub_options
    #   Edition.proof_types[0..-2]
    # end

    def self.options
      [
        [
        'proof edition', ['proofs', Edition.proof_values]
        ]
      ]
    end
  end

  ##############################################################################

  # class NumberedXy
  #   extend Category
  #
  #   def self.options
  #     Edition.proof_types
  #   end
  # end
  #
  # #only needed if we distinguish between text and number cast/field
  # class RomanNumberedXy
  #   extend Category
  #
  #   def self.options
  #     Edition.proof_types
  #   end
  # end
  #
  # class NumberedQty
  #   extend Category
  #
  #   def self.options
  #     Edition.proof_types
  #   end
  # end
  #
  # class ProofEdition
  #   extend Category
  #
  #   def self.options
  #     Edition.proof_types
  #   end
  # end
  #
  # class SingleEdition
  #   extend Category
  #
  #   def self.options
  #     Edition.proof_types
  #   end
  # end

end
