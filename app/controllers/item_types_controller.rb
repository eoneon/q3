class ItemTypesController < ApplicationController
  def create
    @artist = Artist.find(params[:artist_id])
    @item_type = @artist.item_types.build(item_type_params)

    @artist.item_types << @item_type

    if @item_type.save
      respond_to do |format|
        format.js
      end
    end
  end

  def update
    @artist = Artist.find(params[:artist_id])
    @item_type = ItemType.find(params[:id])
    @item_type.assign_attributes(item_type_params)

    if @item_type.save
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @artist = Artist.find(params[:artist_id])
    @item_type = ItemType.find(params[:id])

    if @item_type.destroy
      respond_to do |format|
        format.js
      end
    end
  end

  private

  def item_type_params
    params.require(:item_type).permit!
  end
end
