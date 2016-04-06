class Artist
  include Neo4j::ActiveNode
  property :mbid, index: :exact
  property :name, type: String
  property :listenings, type: Integer
  property :visited, type: Boolean
  property :updated_at

  attr_accessor :matching

  has_many :both, :similar, type: :similar, model_class: :Artist

  def graph(depth = 2, limit = 10)
    lfma = LFM::Artist.new(:name => self.name, :mbid => self.mbid)
    self.update_attributes listenings: lfma.listenings, visited: true
    puts "Get the sons of #{self.name}"
    lfma.get_similar(limit).each do |match, lfma_son|
      similar = Artist.where(name: lfma_son.name).first
      unless similar
        similar = Artist.create(name: lfma_son.name, mbid: lfma_son.mbid)
      end
      self.create_rel(:similar, similar, matching: match)
      begin
        if depth > 0
          similar.graph(depth - 1)
        else
          similar.update listenings: lfma_son.listenings
        end
      rescue Exception
      end unless similar.visited
    end
  end

  def as_json(*params)
    super(*params).values.pop
  end
end
