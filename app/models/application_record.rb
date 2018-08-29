class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def req_meth(req_path, params)
    obj_path = req_path[req_path.index(params[:controller])-1..req_path.index(params[:id])]
    req_path.partition(obj_path)
  end
end
