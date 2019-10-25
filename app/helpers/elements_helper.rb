module ElementsHelper
  def format_option_group_name(opt)
    name = opt.name.split('_with_').join(' with ').split(' ').map {|i| i.split('_').join('-')}.join(' ')
    opt.kind == "option-group" ? "#{name} options" : name
  end
end
