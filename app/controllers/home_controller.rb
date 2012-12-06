class HomeController < ApplicationController
  def index
    @artists = Artist.find :all, :order => 'listenings DESC'
    @artist_edges = ArtistEdge.find :all
  end
end
