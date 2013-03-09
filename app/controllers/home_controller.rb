class HomeController < ApplicationController
  def index
    @artists = []
    i=0
    Artist.find(:first).bfs do |a|
      break unless i < 300
      i+=1
      @artists << a
    end if Artist.find(:first)
  end
end
