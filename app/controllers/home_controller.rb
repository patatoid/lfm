class HomeController < ApplicationController
  def index
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
