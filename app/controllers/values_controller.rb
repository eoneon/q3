 class ValuesController < ApplicationController
  def index
    @values = Value.all
  end

  def create
    #@value = Value.new(value_params)
    @field = Field.find(params[:field_id])
    @value = @field.values.build(value_params)
    @field.values << @value

    if @value.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js
      end
    end
  end

  def update
    #@field = Field.find(params[:field_id])
    @value = Value.find(params[:id])
    @value.assign_attributes(value_params)

    if @value.save
      @form_id = params[:form_id]
      respond_to do |format|
        if @form_id.split("-").include?("properties")
          format.js {render file: "/values/properties_update.js.erb"}
        else
          format.js
        end
      end
    end
  end

  def destroy
    @value = Value.find(params[:id])

    if @value.destroy
      @dom_ref = params[:dom_ref]
      respond_to do |format|
        format.js
      end
    end
  end

  def import
    Value.import(params[:file])
    redirect_to values_path, notice: 'Field Values imported.'
  end

  private

  def value_params
    params.require(:value).permit!
  end
end
