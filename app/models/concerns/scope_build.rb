require 'active_support/concern'

module ScopeBuild
  extend ActiveSupport::Concern

  class_methods do
    def option_types
      %w[origin-type origin-class option-group option-key assoc-key option-value]
    end
  end

end
