module ProductElement
  extend BuildSet

  def self.product_elements
    [Medium, Material, Edition, Signature, Certificate, Dimension, Mounting]
  end

  def self.populate
    product_elements.each do |product_constant|
      to_scoped_constant(product_constant, :boolean_tag).instance_methods(false).each do |instance_method|
        to_scoped_constant(product_constant, :boolean_tag).new.public_send(instance_method).each do |element_name|
          element = find_or_create_by(kind: product_constant.to_s.underscore, name: element_name)
          update_tags(element, h ={element_name.to_s => 'true'})
        end
      end
    end
  end
end
