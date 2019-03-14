require 'active_support/concern'

module Sti
  extend ActiveSupport::Concern

  def grouped_subklass(target)
    self.item_groups.where(target_type: target).order(:sort)
  end

  def list_models
    Dir.glob("#{Rails.root}/app/models/product_part/*.rb").map{|x| x.split("/").last.split(".").first.camelize}
  end
end
