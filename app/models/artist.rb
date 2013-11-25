class Artist < ActiveRecord::Base
  acts_as_graph :directed => true

  attr_accessible :name, :mbid, :listenings

  def graph(depth = 2)
    lfma = LFM::Artist.new(:name => self.name, :mbid => self.mbid)
    as = elf.update_attribute :listenings, lfma.listenings
    puts "Get the sons of #{self.name}"
    lfma.get_similar.collect do |match, lfma_son|
      a = Artist.find_or_create_by_name_and_mbid(lfma_son.name, lfma_son.mbid)
      if a.listenings.nil?
        begin
          a.graph(depth - 1) unless depth == 0 
        rescue Exception
        end
      end
      {:parent_id => self.id, :child_id => a.id, :weight => match}
    end
    ArtistEdge.create(as)
  end
end
