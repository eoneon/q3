module OptionGroupAssoc
  extend BuildSet

  def self.populate
    [SignatureCertificate].each do |option_constant|
      option_constant.instance_methods(false).each do |instance_method|
        elements = Element.where(kind: option_constant.to_s.underscore)
        update_tags(option_group, h={"option_type" => to_snake(option_constant.to_s)})
      end
    end
  end

  class SignatureCertificate
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
  end
end
