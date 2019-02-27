class MediaController < ApplicationController
  def create
    @origin = set_origin
    @medium = @origin.media.build(medium_params)
    @origin.media << @medium

    if @medium.save
      @form_id = params[:form_id]

      respond_to do |format|
        format.js
      end
    end
  end

  def update
    @origin = set_origin
    @medium = Medium.find(params[:id])
    @medium.assign_attributes(medium_params)

    if @medium.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js 
      end
    end
  end

  private

  def medium_params
    params.require(:medium).permit!
  end
end
