class PolyValuesController < ApplicationController
  def create
    @field = Field.find(params[:field_id])
    @value = @field.fields.build(value_params)
    @field.values << @value

    if @field.save
      @form_id = params[:form_id]

      respond_to do |format|
        format.js {render file: "/fields/poly_values/create.js.erb"}
      end
    end
  end

  def update
    @field = Field.find(params[:field_id])
    @value = Value.find(params[:id])
    @value.assign_attributes(value_params)

    if @value.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js {render file: "/fields/poly_values/update.js.erb"}
      end
    end
  end

  private

  def value_params
    params.require(:value).permit!
  end
end
