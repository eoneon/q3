require 'active_support/concern'

module CertificateType
  extend ActiveSupport::Concern

  class_methods do
    def types
      %w[standard animation]
    end

    def standard
      ['standard-certificate', 'publisher-certificate']
    end

    def animation
      ['animation-seal', 'sports-seal', 'animation-certificate']
    end
  end
end
