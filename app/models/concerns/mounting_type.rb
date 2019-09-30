require 'active_support/concern'

module MountingType
  extend ActiveSupport::Concern

  class_methods do
    def types
      %w[two-d three-d]
    end

    def two_d
      ['framed', 'bordered', 'matted', 'wall-mount']
    end

    def three_d
      ['case', 'base', 'wall-mount']
    end
  end
end
