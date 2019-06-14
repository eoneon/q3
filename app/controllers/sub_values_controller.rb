class SubValuesController < ApplicationController
  def create
    @item_field = ItemField.find(params[:item_field_id])
    @sub_value = build_sub_value

    if @sub_value.save
      assoc_sub_value
      @form_id = params[:form_id]

      respond_to do |format|
        format.js
      end
    end
  end

  private

  def sub_value_params
    #params.require(:"#{target_param}").permit!
    params.require(:item_value).permit!
  end

  # def target_param
  #   if params[:action] == "create"
  #     "item_field"
  #   else
  #     helpers.obj_assocs(@item_field).detect {|sti| params[:"#{sti}"].present?}
  #   end
  # end

  def build_sub_value
    helpers.to_konstant(sub_value).new(sub_value_params)
  end

  def sub_value
    helpers.to_snake(params[:item_value][:type])
  end

  def assoc_sub_value
    @item_field.public_send(sub_value.pluralize) << @sub_value
  end
end
