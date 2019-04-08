class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def set_origin
    helpers.to_konstant(origin_key).find(params[:"#{origin_key}_id"])
  end

  def set_target
    helpers.to_konstant(target_key).find(params[:item_group][:"#{target_key}_id"])
  end

  def origin_key
    ['product_part', 'item_field', 'item_value'].detect {|sti| params[:"#{sti}_id"].present?}
  end

  def target_key
    helpers.obj_assocs(@origin).detect {|sti| params[:item_group][:"#{sti}_id"].present?}
  end

  def render_filepath
    [params[:controller], partial_param].reject {|i| i.nil?}.join('/')
  end

  def partial_param
    if params[:controller] == 'item_groups'
      partialize(@target)
    elsif @origin.present?
      partialize(@origin)
    elsif origin_key.present?
      @origin = set_origin
      origin_key.pluralize
    end
  end

  def partialize(obj)
    helpers.to_super_klass_name(obj).underscore.pluralize
  end

  def sti_params
    if subklass_name = helpers.sti_sibs(superklass_name.to_sym).detect {|sti| params[:"#{sti}"].present?}
      subklass_name
    else
      superklass_name
    end
  end

  def superklass_name
   params[:controller].singularize
  end

  def build_join(origin_obj, target_obj)
    origin_obj.public_send(helpers.to_kollection_name(target_obj)) << target_obj
  end

  def swap_sort(origin_obj, pos)
    sort_obj = ItemGroup.find(params[:id])
    sort = sort_obj.sort
    sort2 = pos == -1 ? sort - 1 : sort + 1

    sort_obj2 = origin_obj.item_groups.where(sort: sort2, target_type: sort_obj.target_type)
    sort_obj2.update(sort: sort)
    sort_obj.update(sort: sort2)
  end

  def reset_sort(origin_obj, sort, type)
    grouped_by_type = origin_obj.sti_item_groups(type)
    grouped_by_type.where("sort > ?", sort).each do |sort_obj|
      sort_obj.update(sort: sort_obj.sort - 1)
    end
  end
end
