class ProductPartsController < ApplicationController
  def index
    @product_parts = ProductPart.all.order("type ASC, name ASC")

    respond_to do |format|
      format.xlsx {response.headers['Content-Disposition'] = "attachment; filename='product_parts.xlsx'"}
      format.csv { send_data @product_parts.to_csv }
      format.html
    end
  end

  def show
    @product_part = ProductPart.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def create
    @product_part = ProductPart.new(product_part_params)

    if @product_part.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js
      end
    end
  end

  def update
    @product_part = ProductPart.find(params[:id])
    prev_category = @product_part.category
    @product_part.assign_attributes(product_part_params)

    if @product_part.save
      @form_id = params[:form_id]
      respond_to do |format|
        format.js {render file: "/product_parts/#{render_partial(prev_category)}"}
      end
    end
  end

  def destroy
    @product_part = ProductPart.find(params[:id])

    if @product_part.destroy
      ItemGroup.where(target_id:params[:id]).destroy_all
      respond_to do |format|
        format.js
      end
    end
  end

  def import
    ProductPart.import(params[:file])
    redirect_to product_kinds_path, notice: 'ProductParts imported.'
  end

  private

  def obj_key
    obj_key = params[:form_id].split('-')[0].to_sym
  end

  def product_part_params
    params.require(obj_key).permit!
  end

  # def search_ids
  #   ids = params[:search_ids][1..-2].split(',').map! {|n| n.to_i}
  #   if @product_part.category == "1" && ids.exclude?(params[:id].to_i)
  #     ids << params[:id].to_i
  #   elsif @product_part.category == "0" && ids.include?(params[:id].to_i)
  #    ids - [params[:id].to_i]
  #   end
  # end

  def render_partial(prev_category)
    if @product_part.category != prev_category
      "category_update.js.erb"
    else
      "update.js.erb"
    end
  end
end
