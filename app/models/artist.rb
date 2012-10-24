class Artist < ActiveRecord::Base
#  acts_as_graph

  def graph(depth = 2)
    return if depth == 0 
    lfma = LFM::Artist.new(:name => self.name, :mbid => self.mbid)
    self.listenings = lfma.listenings
  end
end
