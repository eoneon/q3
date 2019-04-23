class SearchProductPartsController < ApplicationController
  def index
    ids = params[:product_part][:ids][1..-2].split(',')
    # ids = params[:product_part][:ids]
    @product_parts = ProductPart.where(id: ids)

    # if where_clause.count == 0
    #   ProductPart.all
    # else
    #   ProductPart.where(where_clause)
    # end

    respond_to do |format|
      format.js
    end
  end

  private

  def build_query
    [:category, :type].map {|k| set_kv_pair(k)}.inject({}){|h, kv_pair| h.merge!(kv_pair)}
  end

  def set_kv_pair(k)
    params[:product_part][k] == "0" || !params[:product_part][k].present? ? {} : {k => params[:product_part][k]}
  end
end
