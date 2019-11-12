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

  def self.search_dropdown
    product_elements.map {|kind| [to_snake(kind.to_s).pluralize, to_snake(kind.to_s)]}.prepend(['all kinds', 'product_elements']).append(['option-groups', 'option_group'])
  end
end
