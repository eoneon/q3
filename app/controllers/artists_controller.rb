class ArtistsController < ApplicationController
  def index
    @artists = Artist.all.order("properties -> 'lastname'")
  end

  def show
    @artists = Artist.all.order("properties -> 'lastname'")
    @artist = Artist.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def create
    @artist = Artist.new(artist_params)

    if @artist.save
      @artists = Artist.all.order("properties -> 'lastname'").to_a

      respond_to do |format|
        format.js
      end
    end
  end

  def update
    @artist = Artist.find(params[:id])
    @artist.assign_attributes(artist_params)

    if @artist.save
      @artists = Artist.all.order("properties -> 'lastname'").to_a

      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    artist = Artist.find(params[:id])

    if artist.destroy
      @artists = Artist.all.order("properties -> 'lastname'").to_a

      respond_to do |format|
        format.js
      end
    end
  end

  def import
    Artist.import(params[:file])
    redirect_to artists_path, notice: 'Artists imported.'
  end

  private

  def artist_params
    params.require(:artist).permit!
  end
end
