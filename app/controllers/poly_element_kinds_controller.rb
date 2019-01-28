class PolyElementKindsController < ApplicationController
  def create
    @elementable = set_parent
    @element_kind = @elementable.element_kinds.build(element_kind_params)
    @elementable.element_kinds << @element_kind

    if @element_kind.save
      @form_id = params[:form_id]

      respond_to do |format|
        format.js {render file: "/element_kinds/poly_element_kinds/create.js.erb"}
      end
    end
  end

  def update
    @elementable = set_parent
    @element_kind = Field.find(params[:id])
    @element_kind.assign_attributes(element_kind_params)

    if @element_kind.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js {render file: "/element_kinds/poly_element_kinds/update.js.erb"}
      end
    end
  end

  private

  def element_kind_params
    params.require(:element_kind).permit!
  end
end
