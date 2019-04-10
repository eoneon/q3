class ItemValue < ApplicationRecord
  include Importable
  include Sti

  before_create :set_properties
  before_save :reset_text_values

  def set_properties
    text_keys.map {|k| self.properties = {"#{k}"=>"#{name}","#{k}_value"=>"#{name}"}}
  end

  def text_keys
    ['tagline', 'description', 'attribute']
  end

  def checkbox_params
    [[name, 'default'], ['omit', 'omit'], ['custom', 'custom']]
  end

  def reset_text_values
    text_keys.each do |k|
      if properties.nil?
        self.properties = {"#{k}"=>"#{name}","#{k}_value"=>"#{name}"}
      elsif !properties.key?(k) #|| properties[k] != 'custom' && properties[k] != 'omit'
        self.properties[k] = name
        self.properties["#{k}_value"] = name
      elsif properties[k] != 'custom' && properties[k] != 'omit'
        self.properties[k] = name
        self.properties["#{k}_value"] = name
      elsif properties[k] == 'omit' || (properties[k] == 'custom' && properties["#{k}_value"] == name)
        self.properties["#{k}_value"] = ""
      end
    end
  end
end
