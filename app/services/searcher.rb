class Searcher
  include ActiveModel::Model

  attr_accessor :max_listenings, :min_listenings, :depth, :artists, :artist, :links

  def initialize(params)
    super(params)
    @depth = 1 if @depth.blank? || @depth.to_i > 6
    @artists = @artist.query_as(:source).match("source<-[similarity:similar*1..#{@depth}]-(artist:Artist)")
    @artists = @artists.where('artist.listenings < ?', params[:max_listenings].to_i) if params[:max_listenings].present?
    @artists = @artists.where('artist.listenings > ?', params[:min_listenings].to_i) if params[:min_listenings].present?
    @artists = @artists.order('artist.listenings desc')
    @artists = @artists.limit(100)
    @artists = @artists.pluck('DISTINCT(artist)')
    @links = Neo4j::Session.query("MATCH (source:Artist)-[rel:similar]->(target:Artist) WHERE source.mbid IN #{@artists.map(&:mbid).compact} AND target.mbid IN #{@artists.map(&:mbid).compact} RETURN source.mbid, target.mbid, rel.matching")
    @links = @links.to_a.map { |e| [e['source.mbid'], e['target.mbid'], e['rel.matching']]}
  end
end
