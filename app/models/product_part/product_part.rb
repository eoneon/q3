class ProductPart < ApplicationRecord
  include Importable

  def sorted_item_groups
    self.item_groups.order(:sort)
  end

  def grouped_subklass(target)
    self.item_groups.where(target_type: target).order(:sort)
  end

  # def self.descendants
  #   ObjectSpace.each_object(Class).select { |klass| klass < self }
  # end

  #def self.kids
    #ObjectSpace.each_object(Class).select { |o| o < MainClass }.tap { |siblings| siblings.reject! { |klass| siblings.any? { |k| klass < k } } }
    #self.all.each.pluck(:type).uniq
  #end
end
