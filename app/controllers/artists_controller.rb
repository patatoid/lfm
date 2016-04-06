class ArtistsController < ApplicationController
  def search
    render json: LFM::Artist.search(params[:q]).reject { |e| e.mbid.blank? }.map(&:to_json)
  end

  def similar
    @artist = Artist.find_by(mbid: params[:id])
    @searcher = Searcher.new(searcher_params.merge(artist: @artist))
    # raise @searcher.links.inspect
    render json: @searcher
  end

  private

  def searcher_params
    params.require(:searcher).permit(:max_listenings, :min_listenings, :depth)
  end
end
