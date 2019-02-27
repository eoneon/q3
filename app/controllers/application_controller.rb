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
    poly_klasses = %w[product_kind medium material sub_medium edition signature certificate mounting dimension product category artist element element_kind]
    if poly_klass = poly_klasses.detect { |pk| param_key[:"#{pk}_id"].present? }
      poly_klass.camelize.constantize.find param_key[:"#{poly_klass}_id"]
    end
  end

  def obj_kollection(origin_obj, target_obj)
    origin_obj.public_send(target_obj.class.name.underscore.pluralize)
  end

  def build_join(origin_obj, target_obj)
    obj_kollection(origin_obj, target_obj) << target_obj
    #origin_obj.item_groups.first.update(origin_type: origin_obj.type)
  end

  # def kill_join(origin_obj, target_obj)
  #   obj_kollection(origin_obj, target_obj).destroy(target_obj)
  # end

  def target_klass
    params[:controller].singularize.camelize.constantize
  end

  def target_method
    params[:controller]
  end

  def swap_sort(parent, pos)
    sort_obj = target_klass.find(params[:id])
    sort = sort_obj.sort
    sort2 = pos == -1 ? sort - 1 : sort + 1

    sort_obj2 = parent.public_send(target_method).where(sort: sort2)
    sort_obj2.update(sort: sort)
    sort_obj.update(sort: sort2)
  end

  def reset_sort(parent, sort)
    parent.public_send(target_method).where("sort > ?", sort).each do |sort_obj|
      sort_obj.update(sort: sort_obj.sort - 1)
    end
  end

  # def set_parent
  #   parent_klasses = %w[product category artist element element_kind]
  #   if klass = parent_klasses.detect { |pk| params[:"#{pk}_id"].present? }
  #     klass.camelize.constantize.find params[:"#{klass}_id"]
  #   end
  # end
end
