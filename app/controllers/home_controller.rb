class HomeController < ApplicationController
  def index
    if params[:artist]
      @artist = Artist.find_by_name(params[:artist][:name])
    else
      @artist = Artist.find(:first)
    end
    @artists = []
    if @artist
      i=0
      @artist.bfs do |a|
        break unless i < 200
        i+=1
        @artists << a
      end
    else
      flash[:warning] = 'artist not found' unless @search_results
    end
  end

  def search_results
    if params[:artist_search]
      @search_results = LFM::Artist.search(params[:artist_search][:name]).collect do |lfma|
        Artist.where("EXISTS (SELECT * FROM artist_edges WHERE parent_id = artists.id)").find_by_name(lfma.name)
      end.compact!
    end
    render :layout => false
  end

  %w(home search contact).each do |n|
    define_method(n) do
      render layout: false
    end
  end
end
