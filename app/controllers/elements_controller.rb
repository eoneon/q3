class ElementsController < ApplicationController
  def index
    @elements = Element.all

    respond_to do |format|
      format.xlsx {response.headers['Content-Disposition'] = "attachment; filename='elements.xlsx'"}
      format.csv { send_data @elements.to_csv }
      format.html
    end
  end

  def show
    @element = Element.find(params[:id])
    respond_to do |format|
      format.js
    end
  end
  #
  # def create
  #   @element = Element.new(element_params)
  #   @elements = Element.all
  #   if @element.save
  #     @form_id = params[:form_id]
  #     respond_to do |format|
  #       format.js
  #     end
  #   end
  # end
  #
  # def update
  #   @element = Element.find(params[:id])
  #   @element.assign_attributes(element_params)
  #
  #   if @element.save
  #     @form_id = params[:form_id]
  #     respond_to do |format|
  #       format.js
  #     end
  #   end
  # end
  #
  # def destroy
  #   @element = Element.find(params[:id])
  #
  #   if @element.destroy
  #     respond_to do |format|
  #       format.js
  #     end
  #   end
  # end

  private

  def element_params
    params.require(:element).permit!
  end
end
