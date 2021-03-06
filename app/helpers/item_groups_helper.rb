module ItemGroupsHelper
  def product_part_fields(product_part)
    product_part.sti_item_groups(product_part.sti_field_type)
  end

  def fields_any?(product_part)
    product_part_fields(product_part) if product_part.present? && product_part.sti_item_groups(product_part.sti_field_type).any?
  end

  def relation_and_fields_any?(parent_obj, product_part)
    fields_any?(product_part) if parent_obj.to_kollection(product_part).any?
  end

  def origin_sti_item_groups?(origin, type, *origin_id)
    if origin.present? && origin.sti_item_groups(type).any?
      origin.sti_item_groups(type).where.not(target_id: origin.id)
    end
  end

  def item_field_values(item_field)
    item_field.sti_item_groups(item_field.sti_value_type)
  end

  def values_any?(item_field)
    item_field_values(item_field) if item_field.present? && item_field.sti_item_groups(item_field.sti_value_type).any?
  end
end
