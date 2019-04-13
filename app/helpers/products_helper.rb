module ProductsHelper
  def product_parts_for_products
    [:product_kind, :medium, :material]
  end

  def nested_selects(product, f, *product_parts)
    product_parts.each do |product_part|
      if part = relation_any?(parent_obj, product_part)
        render(partial: "products/forms/select", locals: {f: ff, product_part: part})
        if fields = fields_any?(part)
          render(partial: "item_fields/fields/#{field.field_type}", locals: {f: ff, field: field})
        end
      end
    end
  end

  def build_clause(product, *product_parts)
    clause =[]
    product_parts.each do |product_part|
      if part = relation_any?(parent_obj, product_part)
        if fields = fields_any?(part)
          clause << fields.map {|field| field.name}
        else
          clause << part.name
        end
      end
    end
    clause.flatten.join(' ').compact.join(' ')
  end
end
