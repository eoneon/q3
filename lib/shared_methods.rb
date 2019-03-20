class SharedMethods
  def dir_list(*model_dir)
    model_dir = format_model_dirs(*model_dir)
    model_names = []
    model_dir.each do |dir|
      filepaths = get_filepaths(dir)
      model_names << get_filename(filepaths)
      end
    end
    model_names
  end

  def to_kollection_name(obj)
    to_snake(obj).pluralize
  end

  def to_snake(obj)
    if obj.class == String
      obj.underscore.singularize
    elsif obj.class == Symbol
      obj.to_s.underscore.singularize
    else
      obj.class.name.underscore
    end
  end
end
