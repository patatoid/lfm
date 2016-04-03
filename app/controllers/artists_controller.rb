class ArtistsController < ApplicationController
  def search
    render json: LFM::Artist.search(params[:q]).reject { |e| e.mbid.blank? }.map(&:to_json)
  end

  def similar
    @artist = Artist.find_by(mbid: params[:id])
    # raise @artist.inspect
    @artists = @artist.similar(:artist)
    @artists = @artists.where('artist.listenings < ?', params[:max_listenings].to_i) if params[:max_listenings].present?
    @artists = @artists.where('artist.listenings > ?', params[:min_listenings].to_i) if params[:min_listenings].present?
    render json: @artists
  end
end
