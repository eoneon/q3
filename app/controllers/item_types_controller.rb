class ItemTypesController < ApplicationController
  def show
    @item_type = ItemType.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

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
    # @item_typeable = set_parent
    @artist = Artist.find(params[:artist_id])
    @item_type = ItemType.find(params[:id])
    @item_type.assign_attributes(item_type_params)

    if @item_type.save
      respond_to do |format|
        format.js
      end
    end
  end

  def sort_up
    @artist = Artist.find(params[:artist_id])
    swap_sort(@artist, -1)

    respond_to do |format|
      format.js {render file: "/item_types/sorter.js.erb"}
    end
  end

  def sort_down
    @artist = Artist.find(params[:artist_id])
    swap_sort(@artist, 1)

    respond_to do |format|
      format.js {render file: "/item_types/sorter.js.erb"}
    end
  end

  def destroy
    @artist = Artist.find(params[:artist_id])
    @item_type = ItemType.find(params[:id])
    sort = @item_type.sort

    if @item_type.destroy
      reset_sort(@artist, sort)

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
