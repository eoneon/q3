module StiSibHelper
  def sti_sibs(*folder_names)
    dir_list(folder_names)
  end

  def sti_sibs_classified(*folder_names)
    dir_list(folder_names).map {|folder_name| folder_name.classify}
  end

  def product_part_search_vl(*sti_superklass)
    dir_list(sti_superklass).map {|subklass| ["show #{subklass}", subklass.classify]}.unshift(["show all product parts", nil])
  end

  def sti_abbrv_vl(*folder_names)
    dir_list(folder_names).map {|folder_name| [abbrv_sti(folder_name), folder_name.classify]}
  end

  def abbrv_sti(folder_name)
    glob_type = normalize_type(folder_name)
    abbrv_sti_key.has_key?(glob_type.to_sym) ? abbrv_sti_key[glob_type.to_sym] : glob_type
  end

  def normalize_type(folder_name)
    arr = folder_name.split("_") - ["field", "value"]
    arr.join("_")
  end

  def abbrv_type(type)
    arr = to_snake(type).split("_") - ["field", "value"]
    obj = arr.join("_")
    abbrv_sti_key[obj.to_sym]
  end

  def abbrv_sti_key
    {medium: 'Medium', product_kind: 'ProductKind', material: 'Material', certificate: 'Certificate', edition: 'Edition', dimension: 'Dimension', mounting: 'Mounting', signature: 'Signature', sub_medium: 'Submedia'}
  end

  def ordered_types
    ['Medium', 'SubMedium', 'Material', 'Edition', 'Mounting', 'Signature', 'Certificate', 'Dimension']
  end

  def dir_list(folder_names)
    model_dirs = to_model_dirs(folder_names) #=>["models/product_part"]
    model_names = []
    model_dirs.each do |model_dir|
      filepaths = get_filepaths(model_dir)
      model_names << get_filename(filepaths)
    end
    model_names.flatten
  end

  #validate params
  def to_model_dirs(folder_names)
    if folder_names == [:all]
      ['models'] << format_model_name(sub_dirs)
    elsif include_all?(folder_names, sub_dirs)
      format_model_name(folder_names)
    end
  end

  #convert symbolized model names to strings matching directory path pattern
  def format_model_name(folder_names)
    folder_names.map {|folder_name| ['models', folder_name.to_s].join('/')}
  end

  #permitted list of subdirectories
  def sub_dirs
    [:product_part, :item_field, :item_value]
  end

  #collect directory-specific paths of model files
  def get_filepaths(dir)
    Dir.glob("#{Rails.root}/app/#{dir}/*.rb")
  end

  #parse filename from filepath: here is where super_types should be rejected
  def get_filename(filepaths)
    filenames = []
    filepaths.each do |path|
      model_name = path.split("/").last.split(".").first
      filenames << model_name if valid_type?(model_name)
    end
    filenames.flatten
  end

  def valid_type?(model_name)
    sub_dirs.exclude?(model_name.to_sym)
  end

  ###
  def item_field_type_vl(*sti_superklass)
    fields = ItemField.all
    vl = [["all field names", fields.ids]]
    dir_list(sti_superklass).each do |type|
      vl << type_any?(type, fields)
    end
    vl.compact
  end

  def item_value_type_vl(*sti_superklass)
    values = ItemValue.all
    vl = [["all field values", values.ids]]
    dir_list(sti_superklass).each do |type|
      vl << type_any?(type, values)
    end
    vl.compact
  end

  def product_part_type_vl(*sti_superklass)
    pps = ProductPart.all
    cat_pps = pps.where(category: "1")

    vl = [["all product parts", pps.ids]]
    vl << ["all top-level product parts", cat_pps.ids]
    vl2 = []
    dir_list(sti_superklass).each do |type|
      vl << type_any?(type, pps)
      vl2 << cat_type_any?(type, cat_pps)
    end
    vl.compact + vl2.compact
  end

  def type_any?(type, objs)
    sti = objs.where(type: type.classify)
    ["show #{type.pluralize}", sti.ids] if sti.any?
  end

  def cat_type_any?(type, cat_pps)
    sti = cat_pps.where(type: type.classify)
    ["show top-level #{type.pluralize}", sti.ids] if sti.any?
  end
end
