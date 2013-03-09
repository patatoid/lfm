class Artist < ActiveRecord::Base
  acts_as_graph :directed => true

  attr_accessible :name, :mbid, :listenings

  def graph(depth = 2)
    lfma = LFM::Artist.new(:name => self.name, :mbid => self.mbid)
    self.update_attribute :listenings, lfma.listenings
    lfma.get_similar.each do |match, lfma_son|
      a = Artist.find_or_create_by_name_and_mbid(lfma_son.name, lfma_son.mbid)
      ArtistEdge.create(:parent_id => self.id, :child_id => a.id, :weight => match)
      if a.listenings.nil?
        begin
          a.graph(depth - 1) unless depth == 0 
        rescue Exception
        end
      end
    end
  end
end
