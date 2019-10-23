module OptionGroupAssoc
  extend BuildSet

  def self.populate
    elements = Element.all
    [Edition, Medium, Dimension, Mounting, SignatureCertificate].each do |option_constant|
      to_scoped_constant(option_constant, :option_group_set).instance_methods(false).each do |instance_method|
        product_elements = elements.where(to_scoped_constant(option_constant, :option_group_match).new.public_send(instance_method))
        option_group = elements.find_by(kind: 'option-group', name: instance_method.to_s)
        create_product_type(product_elements, option_group)
      end
    end
  end

  def self.create_product_type(product_elements, option_group)
    product_elements.each do |product_element|
      assoc_unless_included(origin: product_element, target: option_group)
    end
  end
end
