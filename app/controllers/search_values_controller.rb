class SearchValuesController < ApplicationController
  def index
    ids = params[:item_value][:ids][1..-2].split(',')
    @item_values = ItemValue.where(id: ids).order("type ASC, name ASC")

    respond_to do |format|
      format.js
    end
  end
end
