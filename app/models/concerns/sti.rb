require 'active_support/concern'

module Sti
  extend ActiveSupport::Concern

  def sti_item_groups(type)
    self.item_groups.where(target_type: type.classify).order(:sort)
  end

  def get_klass_name
    self.class.name
  end

  # def to_snake(obj)
  #   if obj.class == String
  #     obj.underscore.singularize
  #   elsif obj.class == Symbol
  #     obj.to_s.underscore.singularize
  #   else
  #     obj.class.name.underscore
  #   end
  # end
end
