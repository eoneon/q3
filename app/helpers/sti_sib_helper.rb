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

  def abbrv_sti_sibs(*folder_names)
    dir_list(folder_names).map {|folder_name| [abbrv_sti(folder_name), folder_name.classify]}
  end

  def abbrv_sti(folder_name)
    abbrv_sti_key.has_key?(folder_name.to_sym) ? abbrv_sti_key[folder_name.to_sym] : folder_name
  end

  def abbrv_sti_key
    {medium: 'Med', product_kind: 'PrdKd', material: 'Matrl', certificate: 'Cert', edition: 'Ed', dimension: 'Dim', mounting: 'Mount', signature: 'Sig', sub_medium: 'Sub-Med'}
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
end
