require 'active_support/concern'

module EditionType
  extend ActiveSupport::Concern

  class_methods do
    def types
      %w[limited single open]
    end

    def limited
      ['numbered-xy', 'numbered', 'from-an-edition']
    end

    def single
      ['single-edition']
    end

    def open
      ['open-edition']
    end
  end
end
