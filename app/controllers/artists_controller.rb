class ArtistsController < ApplicationController
  def index
    @artists = Artist.ordered_artists

    respond_to do |format|
      format.js
      format.html
    end
  end

  def search
    #@artists = Artist.ordered_artists
    @artist = params[:id].present? ? Artist.find(params[:id]) : nil
    @form_id = params[:form_id]

    respond_to do |format|
      format.js {render file: "/artists/show.js.erb"}
    end
  end

  def create
    @artist = Artist.new(artist_params)
    #@artists = Artist.ordered_artists
    @form_id = params[:form_id]

    if @artist.save
      respond_to do |format|
        format.js
      end
    end
  end

  def update
    @artist = Artist.find(params[:id])
    @artist.assign_attributes(artist_params)
    #@artists = Artist.ordered_artists
    @form_id = params[:form_id]

    if @artist.save
      respond_to do |format|
        format.js {render file: "/artists/create.js.erb"}
      end
    end
  end

  def destroy
    artist = Artist.find(params[:id])

    if artist.destroy
      @artists = Artist.ordered_artists

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
