require 'active_support/concern'

module MaterialType
  extend ActiveSupport::Concern

  class_methods do

    def types
      %w[standard photography sericel sculpture hand-blown hand-made]
    end

    def standard
      %w[canvas paper board metal]
    end

    def photography
      %w[photography-paper]
    end

    def sericel
      %w[sericel]
    end

    def sculpture
      %w[glass ceramic metal synthetic]
    end

    def hand_blown
      %w[glass]
    end

    def hand_made
      %w[hand-made]
    end
  end
end
