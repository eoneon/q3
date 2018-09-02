class ItemsController < ApplicationController
  def index
    @items = Item.all.order(:sku)
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @invoice = Invoice.find(params[:invoice_id])
    @item = Item.new(category_id: params[:category_id], artist_id: params[:artist_id])
  end

  def create
    @invoice = Invoice.find(params[:invoice_id])
    @item = @invoice.items.build(item_params)
    #@item = Item.new(item_params)

    if @item.save
      flash[:notice] = "Item was saved successfully."
      redirect_to request.referer
    else
      flash.now[:alert] = "Error creating item. Please try again."
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    @item.assign_attributes(item_params)

    if @item.save
      flash[:notice] = "Item was updated successfully."
    else
      flash.now[:alert] = "Error updated item. Please try again."
    end
    redirect_to request.referer
  end

  def destroy
    @item = Item.find(params[:id])

    if @item.destroy
      flash[:notice] = "Item was deleted successfully."
      #redirect_to action: :index
      redirect_to request.referer
    else
      flash.now[:alert] = "There was an error deleting the item."
      render :show
    end
  end

  private

  def item_params
    params.require(:item).permit!
  end
end
