module ApplicationHelper
  def selected_option(obj_ids, collection)
    if intersection = obj_ids & collection.pluck(:id)
      option_id = intersection[0]
    end
    option_id if option_id.present?
  end
end
