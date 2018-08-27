class ArtistsController < ApplicationController
  def index
    @artists = Artist.all

    respond_to do |format|
      format.html
      format.csv { send_data @artists.to_csv, filename: "Artists.csv" }
      format.xls { send_data @artists.to_csv(col_sep: "\t") }
    end
  end

  def show
    @artist = Artist.find(params[:id])
  end

  def new
    @artist = Artist.new
  end

  def edit
    @artist = Artist.find(params[:id])
  end

  def create
    @artist = Artist.new(artist_params)

    if @artist.save
      flash[:notice] = "Artist was saved successfully."
    else
      flash.now[:alert] = "Error creating Artist. Please try again."
    end
    render :edit
  end

  def update
    @artist = Artist.find(params[:id])
    @artist.assign_attributes(artist_params)

    if @artist.save
      flash[:notice] = "artist was updated successfully."
      render :edit
    else
      flash.now[:alert] = "Error updated artist. Please try again."
      render :edit
    end
  end

  def destroy
    @artist = Artist.find(params[:id])

    if @artist.destroy
      flash[:notice] = "\"#{@artist.try(:artist_id)}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error deleting the artist."
      render :show
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
