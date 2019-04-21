class SearchProductPartsController < ApplicationController
  def index
    where_clause = build_query
    @product_parts =

    if where_clause.count == 0
      ProductPart.all
    else
      ProductPart.where(where_clause)
    end

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

  # def build_query
  #   params[:product_part].each_pair {|k,v| set_kv_pair(k,v)}.inject({}){|h, kv_pair| h.merge!(kv_pair)}
  # end
  #
  # def set_kv_pair(k,v)
  #   #params[k] == "0" || !params[k].present? ? {} : {k => params[k]}
  #   v == "0" || !v.present? ? h ={} : h={k => v}
  # end
end
