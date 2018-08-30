class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def params_arr(req_path, params)
    [:controller, :id].map {|k| "/#{params[k]}"}
  end

  def partitioned_path(req_path, params)
    req_path.partition(params_arr(req_path, params)[0])
  end

  def nested_path?(req_path, params)
    partitioned_path(req_path, params)[0].present?
  end

  def dynamic_index(req_path, params)
    nested_path?(req_path, params) ? partitioned_path(req_path, params)[0] : params_arr(req_path, params)[0]
  end

  def dynamic_show(req_path, params)
    nested_path?(req_path, params) ? partitioned_path(req_path, params)[0] + params_arr(req_path, params).join("") : params_arr(req_path, params).join("")
  end

  def dynamic_edit(req_path, params)
    dynamic_show(req_path, params) + "/edit"
  end
end
