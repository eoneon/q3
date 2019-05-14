class SubPartsController < ApplicationController
  def create
    @product_part = ProductPart.find(params[:product_part_id])
    @sub_part = build_sub_part

    if @sub_part.save
      assoc_sub_part
      @form_id = params[:form_id]

      respond_to do |format|
        format.js
      end
    end
  end

  def update
    @product_part = set_origin
    @sub_part = helpers.to_konstant(target_param).find(params[:id])
    @sub_part.assign_attributes(sub_part_params)

    if @sub_part.save
      #@product_parts = ProductPart.all #.order(:sort)
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

  def target_param
    if params[:action] == "create"
      "product_part"
    else
      helpers.obj_assocs(@product_part).detect {|sti| params[:"#{sti}"].present?}
    end
  end

  def sub_part
    helpers.to_snake(params[:product_part][:type])
  end

  def build_sub_part
    helpers.to_konstant(sub_part).new(sub_part_params)
  end

  def assoc_sub_part
    @product_part.public_send(sub_part.pluralize) << @sub_part
  end
end
