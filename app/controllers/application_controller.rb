class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  # def origin_key
  #  ['product_part', 'item_field', 'item_value'].detect {|fk| params[:"#{fk}_id"].present?}
  # end

  # def set_origin
  #   helpers.to_konstant(origin_param).find(params[super_fk])
  # end

  # def set_target
  #   target_fk = helpers.to_fk(target_param)
  #   helpers.to_konstant(target_param).find(params[:item_group][target_fk])
  # end
  #
  # def origin_param
  #   dom_ref[0] if permitted_sti_types.include?(dom_ref[0])
  # end
  #
  # def target_param
  #   dom_ref[2] if permitted_sti_types.include?(dom_ref[2])
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

  # def partial_name
  #   params[:controller]
  # end
  #
  # def controller_name
  #   params[:controller]
  # end
  #new
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

  def partialize(obj)
    helpers.to_super_klass_name(obj).underscore.pluralize
  end

  def partial_param
    if params[:controller] == 'item_groups'
      partialize(@target)
    elsif origin_key.present?# @origin = set_origin
      partialize(@origin)
    # else
    #   nil
    end
  end

  def sti_params
    helpers.sti_sibs(superklass_name.to_sym).detect {|sti| params[:"#{sti}"].present?}
  end

  def superklass_name
   params[:controller].singularize
  end
end
