module Certificate
  class BooleanTag
    def standard
      %w[standard-certificate publisher-certificate]
    end

    def animation
      %w[animation-seal sports-seal animation-certificate]
    end

    def standard_animation
      %w[animation-seal sports-seal standard-certificate]
    end

    #######################

    def standard_certificate
      %w[COA LOA]
    end

    def publisher_certificate
      %w[Peter-Max-COA PSA-COA]
    end

    def animation_certificate
      %w[Warner-Bros. Looney-Tunes Hanna-Barbera]
    end

    def animation_seal
      animation_certificate
    end

    def sports_seal
      %w[NFL MLB NHL NBA]
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

    def standard_animation_certificate
      [
        %w[animation-seal sports-seal standard-certificate],
        %w[animation-seal standard-certificate],
        %w[sports-seal standard-certificate],
        %w[sports-seal animation-seal],
        %w[standard-certificate],
        %w[sports-seal]
      ]
    end
  end

  class OptionGroupMatch
    def standard_certificate
      h ={kind: 'certificate', name: BooleanTag.new.standard_certificate}
    end

    def publisher_certificate
      h ={kind: 'certificate', name: BooleanTag.new.publisher_certificate}
    end

    def animation_certificate
      h ={kind: 'certificate', name: BooleanTag.new.animation_certificate}
    end

    def animation_seal
      h ={kind: 'certificate', name: BooleanTag.new.animation_certificate}
    end

    def sports_seal
      h ={kind: 'certificate', name: BooleanTag.new.sports_seal}
    end
  end
end
