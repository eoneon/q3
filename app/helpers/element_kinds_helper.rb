module ElementKindsHelper
  def exclusive_vl(parent_obj, child_obj)
    obj_set = parent_obj.public_send(kollection_name(child_obj)).pluck(:name).uniq
    konstant(child_obj).where.not(name: obj_set)
  end
end
