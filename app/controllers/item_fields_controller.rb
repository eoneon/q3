class ItemFieldsController < ApplicationController
  def index
    @item_fields = ItemField.all.order("type ASC, field_name ASC")

    respond_to do |format|
      format.xlsx {response.headers['Content-Disposition'] = "attachment; filename='item_fields.xlsx'"}
      format.csv { send_data @item_fields.to_csv }
      format.html
    end
  end

  def show
    @item_field = ItemField.find(params[:id])
    respond_to do |format|
      format.js {render file: "/#{render_filepath}/show.js.erb"}
    end
  end

  def create
    @item_field = ItemField.new(item_field_params)

    if @item_field.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js {render file: "/#{render_filepath}/create.js.erb"}
      end
    end
  end

  def update
    @item_field = ItemField.find(params[:id])
    @item_field.assign_attributes(item_field_params)

    if @item_field.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js {render file: "/#{render_filepath}/update.js.erb"}
      end
    end
  end

  def destroy
    @item_field = ItemField.find(params[:id])

    if @item_field.destroy
      ItemGroup.where(target_id: params[:id]).destroy_all
      respond_to do |format|
        format.js {render file: "/#{render_filepath}/destroy.js.erb"}
      end
    end
  end

  def import
    ItemField.import(params[:file])
    redirect_to item_fields_path, notice: 'Item-Fields imported.'
  end

  private

  def item_field_params
    params.require(:"#{sti_params}").permit!
  end
end
