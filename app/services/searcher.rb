class Searcher
  include ActiveModel::Model

  attr_accessor :max_listenings, :min_listenings, :depth, :artists, :artist

  def initialize(params)
    super(params)
    @depth = 1 if @depth.blank? || @depth.to_i > 3
    @artists = @artist.query_as(:source).match("source<-[similarity:similar*1..#{@depth}]-(artist:Artist)")
    @artists = @artists.where('artist.listenings < ?', params[:max_listenings].to_i) if params[:max_listenings].present?
    @artists = @artists.where('artist.listenings > ?', params[:min_listenings].to_i) if params[:min_listenings].present?
    @artists = @artists.order('artist.listenings desc')
    @artists = @artists.limit(50)
    @artists = @artists.pluck('DISTINCT(artist), similarity').map do |res|
      res[0].matching = res[1].inject(1) { |acc, e| acc * e.get_property('matching') }
      res[0]
    end
    @artists = @artists.sort_by(&:matching).reverse
  end
end
