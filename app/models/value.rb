class Value < ApplicationRecord
  belongs_to :field

  has_many :value_groups, dependent: :destroy
  has_many :items, through: :value_groups

  before_create :set_properties
  before_update :reset_properties

  def set_properties
    self.properties["title_value"] = name
    self.properties["body_value"] = name
    self.properties["attribute_value"] = name
  end

  def reset_properties
    # if properties_changed?
      %w(title body attribute).each do |k|
        if properties[k] == 'none'
          properties["#{k}_value"] = ""
        elsif properties[k] == name
          properties["#{k}_value"] = name
        end
      end
    # end
  end
  #before_create :set_sort
  #after_save :set_parent

  # def set_sort
  #   total = Value.count
  #   self.sort = total > 0 ? total + 1 : 1
  # end

  # def sorted_categories
  #   Value.all.order(:sort)
  # end
  # def self.field_keys
  #   %w[parent title body both attribute selected display_hidden display_none]
  # end
end
