class PolyFieldsController < ApplicationController
  def create
    @fieldable = set_parent
    @field = @fieldable.fields.build(field_params)
    @fieldable.fields << @field

    if @field.save
      @form_id = params[:form_id]

      respond_to do |format|
        format.js {render file: "/fields/poly_fields/create.js.erb"}
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
        format.js {render file: "/fields/poly_fields/update.js.erb"}
      end
    end
  end

  private

  def field_params
    params.require(:field).permit!
  end
end
