class ProductPart < ApplicationRecord
  include Importable
  include Sti

  def grouped_subklass(target)
    self.item_groups.where(target_type: target).order(:sort)
  end

  def field_subklass
    self.class.name.camelize + 'Field'
  end

  # def field_kollection
  #   self.public_send(field_kollection_name.pluralize)
  # end

  def self.subklass_list
    ["Medium", "Material", "SubMedium", "Edition", "Dimension", "Mounting", "Signature", "Certificate"]
  end

  # def self.descendants
  #   ObjectSpace.each_object(Class).select { |klass| klass < self }
  # end

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
