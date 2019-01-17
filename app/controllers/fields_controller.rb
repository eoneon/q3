class FieldsController < ApplicationController
  def index
    @fields = Field.all
  end

  def create
    @fieldable = set_parent
    @field = @fieldable.fields.build(field_params)
    @fieldable.fields << @field

    if @field.save
      @field_group = @field.field_groups.first
      @form_id = params[:form_id]

      respond_to do |format|
        format.js
      end
    end
  end

  def update
    @fieldable = set_parent
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
    @fieldable = set_parent
    field = Field.find(params[:id])
    @field_group = field.field_groups.first
    sort = @field_group.sort
    @dom_ref = params[:dom_ref]

    if field.destroy
      reset_sort(@fieldable, sort)

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
