class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def set_fieldable
    parent_klasses = %w[category dimension certificate]
    if klass = parent_klasses.detect { |pk| params[:"#{pk}_id"].present? }
      klass.camelize.constantize.find params[:"#{klass}_id"]
    end
  end

  def target_klass
    params[:controller].singularize.camelize.constantize
  end

  def target_method
    params[:controller]
  end

  def swap_sort(fieldable, pos)
    sort_obj = target_klass.find(params[:id])
    sort = sort_obj.sort
    sort2 = pos == -1 ? sort - 1 : sort + 1

    sort_obj2 = fieldable.public_send(target_method).where(sort: sort2)
    sort_obj2.update(sort: sort)
    sort_obj.update(sort: sort2)
  end

  def reset_sort(fieldable, sort)
    fieldable.public_send(target_method).where("sort > ?", sort).each do |sort_obj|
      sort_obj.update(sort: sort_obj.sort - 1)
    end
  end
end
