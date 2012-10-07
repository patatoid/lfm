class Artist < ActiveRecord::Base
  attr_accessible :listenings, :mbid, :name, :url

  def graph(depth = 2)
    return if depth = 0 
    lfma = LFM::Artist.new(:name => self.name, :mbid => self.mbid)
    self.listenings = lfma.listenings
  end
end
