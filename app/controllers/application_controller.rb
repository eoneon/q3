class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def set_origin
    get_obj(params)
  end

  def set_target
    get_obj(params[:item_group])
  end

  def get_obj(param_key)
    if poly_klass = helpers.sti_sibs(:product_part, :item_field).detect { |pk| param_key[:"#{pk}_id"].present? }
      helpers.to_konstant(poly_klass).find param_key[:"#{poly_klass}_id"]
    end
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
    grouped_by_type = origin_obj.grouped_subklass(type)
    grouped_by_type.where("sort > ?", sort).each do |sort_obj|
      sort_obj.update(sort: sort_obj.sort - 1)
    end
  end

  def partial_param
    request.referrer.split('/')[-1]
  end
end
