class ItemValuesController < ApplicationController
  def index
    @item_values = ItemValue.all.order(:type)

    respond_to do |format|
      format.xlsx {response.headers['Content-Disposition'] = "attachment; filename='item_values.xlsx'"}
      format.csv { send_data @item_values.to_csv }
      format.html
    end
  end

  def show
    @item_value = ItemValue.find(params[:id])
    respond_to do |format|
      format.js {render file: "/#{render_filepath}/show.js.erb"}
    end
  end

  def create
    @item_value = ItemValue.new(item_value_params)

    if @item_value.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js {render file: "/#{render_filepath}/create.js.erb"}
      end
    end
  end

  def update
    @item_value = ItemValue.find(params[:id])
    @item_value.assign_attributes(item_value_params)

    if @item_value.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js {render file: "/#{render_filepath}/update.js.erb"}
      end
    end
  end

  def destroy
    @item_value = ItemValue.find(params[:id])

    if @item_value.destroy
      respond_to do |format|
        format.js {render file: "/#{render_filepath}/destroy.js.erb"}
      end
    end
  end

  def import
    ItemValue.import(params[:file])
    redirect_to item_values_path, notice: 'Item-Values imported.'
  end

  private

  def item_value_params
    params.require(:"#{sti_params}").permit!
  end
end
