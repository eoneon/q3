class SubFieldsController < ApplicationController
  def create
    @product_part = ProductPart.find(params[:product_part_id])
    @sub_field = build_sub_field

    if @sub_field.save
      assoc_sub_field
      @form_id = params[:form_id]

      respond_to do |format|
        format.js
      end
    end
  end

  private

  def sub_field_params
    #params.require(:"#{target_param}").permit!
    params.require(:item_field).permit!
  end

  # def target_param
  #   if params[:action] == "create"
  #     "product_part"
  #   else
  #     helpers.obj_assocs(@product_part).detect {|sti| params[:"#{sti}"].present?}
  #   end
  # end

  def build_sub_field
    helpers.to_konstant(sub_field).new(sub_field_params)
  end

  def sub_field
    helpers.to_snake(params[:item_field][:type])
  end

  def assoc_sub_field
    @product_part.public_send(sub_field.pluralize) << @sub_field
  end
end
