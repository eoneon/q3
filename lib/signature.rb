module Signature

  class OptionGroup
    def self.populate
      self.name
    end
  end

  class BooleanTag
    def standard
      %w[artist relative celebrity]
    end

    def three_d
      %w[artist-3d]
    end
  end

  class OptionGroupSet
    def flat_signature
      [
        %w[artist],
        %w[artist artist],
        %w[artist relative],
        %w[artist celebrity],
        %w[celebrity],
        %w[relative]
      ]
    end

    def sculpture_signature
      [
        %w[artist-3d]
      ]
    end
  end
end
