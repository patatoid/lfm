class Artist < ActiveRecord::Base
  acts_as_graph :directed => true

  attr_accessible :name, :mbid, :listenings

  def graph(depth = 2)
    return if depth == 0 
    lfma = LFM::Artist.new(:name => self.name, :mbid => self.mbid)
    self.update_attribute :listenings, lfma.listenings
    lfma.get_similar.each do |match, lfma_son|
      a = self.children.create(:name => lfma_son.name, :mbid => lfma_son.mbid)
      ArtistEdge.find(:first, :conditions => {:parent_id => self.id, :child_id => a.id}).update_attribute(:weight, match)
      if not a.listenings.to_i == lfma_son.listenings
        a.graph(depth - 1)
      end
    end
  end
end
