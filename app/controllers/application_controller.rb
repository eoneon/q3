class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  # def set_origin
  #   get_obj(params)
  # end
  #
  # def set_target
  #   get_obj(params[:item_group])
  # end
  def origin_key
   ['product_part', 'item_field', 'item_value'].detect {|fk| params[:"#{fk}_id"].present?}
  end

  def set_origin
    helpers.to_konstant(origin_param).find(params[super_fk])
  end

  def set_target
    target_fk = helpers.to_fk(target_param)
    helpers.to_konstant(target_param).find(params[:item_group][target_fk])
  end

  def origin_param
    dom_ref[0] if permitted_sti_types.include?(dom_ref[0])
  end

  def target_param
    dom_ref[2] if permitted_sti_types.include?(dom_ref[2])
  end

  #kill
  # def get_obj(param_key)
  #   if poly_klass = permitted_sti_types.detect { |pk| param_key[:"#{pk}_id"].present? }
  #     helpers.to_konstant(poly_klass).find param_key[:"#{poly_klass}_id"]
  #   end
  # end

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

  def origin_param
    dom_ref[0] if permitted_sti_types.include?(dom_ref[0])
  end

  def target_param
    dom_ref[2] if permitted_sti_types.include?(dom_ref[2])
  end

  #new
  def super_fk
    super_klass_name = helpers.to_super_klass_name(origin_param)
    helpers.to_fk(super_klass_name)
  end

  def permitted_sti_types
    helpers.sti_sibs(:product_part, :item_field)
  end

  def dom_ref
    params[:form_id].split('-')
  end

  def partial_name
    #helpers.to_super_klass_name(@target).underscore.pluralize
    params[:controller]
  end

  def controller_name
    params[:controller]
  end
end
