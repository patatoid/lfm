class Artist < ActiveRecord::Base
  acts_as_graph :directed => true

  attr_accessible :name, :mbid, :listenings, :visited

  def graph(depth = 2)
    lfma = LFM::Artist.new(:name => self.name, :mbid => self.mbid)
    self.update_attributes listenings: lfma.listenings, visited: true
    puts "Get the sons of #{self.name}"
    as = lfma.get_similar.collect do |match, lfma_son|
      a = Artist.find_or_create_by_name_and_mbid(lfma_son.name, lfma_son.mbid)
      unless a.reload.visited
        begin
          unless depth == 0 
            a.graph(depth - 1)
          else
            a.update_attributes listenings: lfma_son.listenings unless a.listenings
          end
        rescue Exception
        end
      end
      {:parent_id => self.id, :child_id => a.id, :weight => match}
    end
    ArtistEdge.create(as)
  end
end
