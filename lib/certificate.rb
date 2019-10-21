module Certificate
  class BooleanTag
    def standard
      %w[standard-certificate publisher-certificate]
    end

    def animation
      %w[animation-seal sports-seal animation-certificate]
    end
  end

  class OptionGroupSet
    def standard_certificate
      [
        %w[standard-certificate],
        %w[publisher-certificate]
      ]
    end

    def animation_certificate
      [
        %w[animation-seal sports-seal animation-certificate],
        %w[animation-seal animation-certificate],
        %w[sports-seal animation-certificate],
        %w[sports-seal animation-seal],
        %w[animation-certificate],
        %w[sports-seal]
      ]
    end
  end
end
