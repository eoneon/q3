module SubCategoriesHelper
  def categorizable_str(sub_category)
    sub_category.categorizable_type.downcase
  end

  def categorizable_name(sub_category)
    [categorizable_str(sub_category), "name", categorizable_id(sub_category)].join("-")
  end

  def categorizable_id(sub_category)
    sub_category.categorizable.id
  end

  def categorizable_href(sub_category)
    [categorizable_str(sub_category), sub_category.categorizable.id].join("-")
  end

  def categorizable_href_target(sub_category, target)
    [categorizable_href(sub_category), target].join("-")
  end

  def categorizable_label(sub_category, action)
    [action, categorizable_str(sub_category)].join(" ").capitalize
  end
end
