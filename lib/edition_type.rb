module EditionType
  #extend Category
  # EditionType::LimitedEdition::NumberedXy.name
  # EditionType::LimitedEdition::option_sets

  def self.proofs
    ['AP', 'EA', 'CP', 'GP', 'PP', 'IP', 'HC', 'TC', 'Japanese']
  end

  def self.limited_types
    ['limited edition', 'sold out limited edition']
  end

  module LimitedEdition
    extend Category
    #extend :proofs and limited_types to individual classes
    # def self.option_sets
    #   self.constants.map {|klass| [scope_context(self, klass).name, scope_context(self, klass).option_set.map {|set| [set.to_s, EditionType.public_send(set)]}]}
    # end

    class NumberedXy
      extend Category

      def self.option_set
        [:proofs, :limited_types]
      end
    end

    class RomanNumberedXy
      extend Category

      def self.option_set
        [:proofs, :limited_types]
      end
    end

    class NumberedQty
      extend Category

      def self.option_set
        [:proofs, :limited_types]
      end
    end

    class NumberedQty
      extend Category

      def self.option_set
        [:proofs, :limited_types]
      end
    end
  end

  module SingleEdition
    extend Category

    # def self.option_sets
    #   self.constants.map {|klass| [scope_context(self, klass).name, scope_context(self, klass).option_set.map {|set| [set.to_s, EditionType.public_send(set)]}]}
    # end

    class NumberedOneOfOne
      extend Category

      def self.option_set
        [:proofs]
      end
    end

  end
end
