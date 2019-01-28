class ElementKindsController < ApplicationController
  def index
    @element_kinds = ElementKind.all
  end

  def show
    @element_kind = ElementKind.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def create
    @element_kind = ElementKind.new(element_kind_params)

    if @element_kind.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js {render file: "/element_kinds/new.js.erb"}
      end
    end
  end

  def update
    @element_kind = ElementKind.find(params[:id])
    @element_kind.assign_attributes(element_kind_params)

    if @element_kind.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @element_kind = ElementKind.find(params[:id])

    if @element_kind.destroy
      respond_to do |format|
        format.js
      end
    end
  end

  private

  def element_kind_params
    params.require(:element_kind).permit!
  end
end
