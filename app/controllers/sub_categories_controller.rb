class SubCategoriesController < ApplicationController
  def create
    @category = SubCategory.find(params[:category_id])
    @sub_category = build_sub_category

    if @sub_category.save
      assoc_sub_category
      @form_id = params[:form_id]

      respond_to do |format|
        format.js
      end
    end
  end

  def update
    @category = set_origin
    @sub_category = helpers.to_konstant(target_param).find(params[:id])
    @sub_category.assign_attributes(sub_category_params)

    if @sub_category.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js
      end
    end
  end

  private

  def sub_category_params
    params.require(:"#{target_param}").permit!
  end

  def target_param
    if params[:action] == "create"
      "category"
    else
      helpers.obj_assocs(@category).detect {|sti| params[:"#{sti}"].present?}
    end
  end

  def sub_category
    helpers.to_snake(params[:category][:type])
  end

  def build_sub_category
    helpers.to_konstant(sub_category).new(sub_category_params)
  end

  def assoc_sub_category
    @category.public_send(sub_category.pluralize) << @sub_category
  end
end
