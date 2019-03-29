class SubPartsController < ApplicationController
  # def create
  #   @origin = set_origin
  #   @medium = @origin.media.build(medium_params)
  #   @origin.media << @medium
  #
  #   if @medium.save
  #     @form_id = params[:form_id]
  #
  #     respond_to do |format|
  #       format.js
  #     end
  #   end
  # end

  def update
    @product_part = helpers.to_konstant(origin_param).find(params[:product_part_id])
    @sub_part = helpers.to_konstant(target_param).find(params[:id])
    @sub_part.assign_attributes(sub_part_params)

    if @sub_part.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js
      end
    end
  end

  private

  def sub_part_params
    params.require(:"#{target_param}").permit!
  end
end
