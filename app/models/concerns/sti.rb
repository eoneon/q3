require 'active_support/concern'

module Sti
  extend ActiveSupport::Concern

  def sti_item_groups(type)
    self.item_groups.where(target_type: type.classify).order(:sort)
  end

  def filtered_types(types)
    types = types.map {|name| name.classify}
    self.item_groups.where(target_type: types).order(:sort)
  end

  def get_klass_name
    self.class.name
  end

  def hello
    puts 'word'
  end
end
