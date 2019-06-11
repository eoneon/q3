module ItemFieldsHelper
  def field_type_vl
    ["select_field", "text_field", "text_area", "number_field", "check_box", "radio_button"]
  end

  def abbrv_field_type_key
    {select_field: "select", text_field: "text", text_area: "area", check_box: "check", radio_button: "radio"}
  end

  def abbrv_field_type_vl
    field_type_vl.map {|type| [abbrv_field_type_key[type.to_sym], type]}
  end

  def hidden_field_type(item_field)
    item_field.field_type ? abbrv_field_type_key[item_field.field_type.to_sym] : "select"  
  end
end
