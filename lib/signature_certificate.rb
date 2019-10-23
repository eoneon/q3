module SignatureCertificate

  class OptionGroupSet
    def flat_signed_with_certificate
      [
        %w[flat_signature standard_certificate],
        %w[flat_signature],
        %w[standard_certificate]
      ]
    end

    def sculpture_signed_with_certificate
      [
        %w[sculpture_signature standard_certificate],
        %w[sculpture_signature],
        %w[standard_certificate]
      ]
    end

    def signed_with_animation_certificate
      [
        %w[flat_signature animation_certificate],
        %w[flat_signature],
        %w[animation_certificate]
      ]
    end

    # def signed_with_standard_animation_certificate
    #   [
    #     %w[flat_signature standard_animation_certificate],
    #     %w[flat_signature],
    #     %w[standard_animation_certificate]
    #   ]
    # end
  end

  class OptionGroupMatch
    def flat_signed_with_certificate
      h ={kind: 'medium', name: %w[painting drawing mixed-media print photography sculpture hand-blown hand-made]}
    end

    def signed_with_animation_certificate
      h ={kind: 'medium', name: 'sericel'}
    end

    def sculpture_signed_with_certificate
      h ={kind: 'medium', name: 'sculpture'}
    end
  end
end
