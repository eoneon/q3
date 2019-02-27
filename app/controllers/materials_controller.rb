class MaterialsController < ApplicationController
  def create
    @origin = set_origin
    @material = @origin.materials.build(material_params)
    @origin.materials << @material

    if @material.save
      @form_id = params[:form_id]

      respond_to do |format|
        format.js
      end
    end
  end

  def update
    @origin = set_origin
    @material = Material.find(params[:id])
    @material.assign_attributes(material_params)

    if @material.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js 
      end
    end
  end

  private

  def material_params
    params.require(:material).permit!
  end
end
