require 'active_support/concern'

module DimensionType
  extend ActiveSupport::Concern

  class_methods do
    def types
      %w[two-d three-d]
    end

    def two_d
      ['width', 'height']
    end

    def three_d
      ['width', 'height', 'depth']
    end
  end
end
