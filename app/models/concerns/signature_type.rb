require 'active_support/concern'

module SignatureType
  extend ActiveSupport::Concern

  class_methods do
    def types
      %w[standard three-d]
    end

    def standard
      ['artist', 'relative', 'celebrity']
    end

    def three_d
      ['artist-3d']
    end
  end
end
