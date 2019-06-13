class SearchFieldsController < ApplicationController
  def index
    ids = params[:item_field][:ids][1..-2].split(',')
    @item_fields = ItemField.where(id: ids).order("type ASC, field_name ASC")

    respond_to do |format|
      format.js
    end
  end

  # private

  # def build_query
  #   [:category, :type].map {|k| set_kv_pair(k)}.inject({}){|h, kv_pair| h.merge!(kv_pair)}
  # end
  #
  # def set_kv_pair(k)
  #   params[:product_part][k] == "0" || !params[:product_part][k].present? ? {} : {k => params[:product_part][k]}
  # end
end
