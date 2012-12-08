class HomeController < ApplicationController
  def index
    @artists = []
    i=0
    Artist.find(:first).bfs do |a|
      break unless i < 100
      i+=1
      @artists << a
    end
  end
end
