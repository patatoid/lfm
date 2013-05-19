class HomeController < ApplicationController
  def index
    if params[:artist]
      @artist = Artist.find_by_name(params[:artist][:name])
    elsif params[:artist_search]
      @search_results = LFM::Artist.search(params[:artist_search][:name]).collect do |lfma|
        Artist.find_by_name(lfma.name)
      end.compact!
    else
      @artist = Artist.find(:first)
    end
    @artists = []
    if @artist
      i=0
      @artist.bfs do |a|
        break unless i < 10
        i+=1
        @artists << a
      end
    else
      flash[:warning] = 'artist not found' unless @search_results
    end
  end
end
