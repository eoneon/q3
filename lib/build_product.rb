class BuildProduct
  extend BuildAppData
  def product_types
    %w[medium material edition signature certificate dimension mounting]
  end

  def build_product_parts
    set =[]
    product_parts.each do |product_part|
      name = to_constant(product_part).scoped_types
      set << kind.new.medium_types
      #element_type_name = scoped_elements.first
      #element_names = scoped_elements.drop(1)
      #element_type = find_or_create_by_name(obj_klass: :element_type, name: element_type_name)
      #find_or_create_scoped_elements_and_assoc(element_type, kind, element_names)
    end
    set
  end
end
