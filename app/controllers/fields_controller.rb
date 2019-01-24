class FieldsController < ApplicationController
  def index
    @fields = Field.all
  end

  def show
    @field = Field.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def create
    @field = Field.new(field_params)

    if @field.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js {render file: "/fields/new.js.erb"}
      end
    end
  end

  def update
    @field = Field.find(params[:id])
    @field.assign_attributes(field_params)

    if @field.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    #@fieldable = set_parent
    @field = Field.find(params[:id])
    #@field_group = field.field_groups.first
    #sort = @field_group.sort


    if @field.destroy
      @dom_ref = params[:dom_ref]
      respond_to do |format|
        format.js
      end
    end
  end

  def import
    Field.import(params[:file])
    redirect_to fields_path, notice: 'Fields imported.'
  end

  private

  def field_params
    params.require(:field).permit!
  end
end
