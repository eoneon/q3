class ElementKindsController < ApplicationController
  def index
    @element_kinds = ElementKind.all

    respond_to do |format|
      format.xlsx {response.headers['Content-Disposition'] = "attachment; filename='element_kinds.xlsx'"}
      format.csv { send_data @element_kinds.to_csv }
      format.html
    end
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

  def import
    ElementKind.import(params[:file])
    redirect_to element_kinds_path, notice: 'Element-Kinds imported.'
  end

  private

  def element_kind_params
    params.require(:element_kind).permit!
  end
end
