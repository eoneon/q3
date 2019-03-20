require 'active_support/concern'

module Sti
  extend ActiveSupport::Concern

  def grouped_subklass(target)
    self.item_groups.where(target_type: target).order(:sort)
  end

  def list_models
    Dir.glob("#{Rails.root}/app/models/product_part/*.rb").map{|x| x.split("/").last.split(".").first.camelize}
  end

  def to_kollection_name(obj)
    to_snake(obj).pluralize
  end

  def to_snake(obj)
    if obj.class == String
      obj.underscore.singularize
    elsif obj.class == Symbol
      obj.to_s.underscore.singularize
    else
      obj.class.name.underscore
    end
  end
end
