task :generate_graph => :environment do
  #Artist.connection.execute("UPDATE artists SET listenings = NULL")
  a = LFM::Artist.search("Portishead")[0]
  a = Artist.find_or_create_by_name_and_mbid(:name => a.name, :mbid => a.mbid)
  Thread.new { a.graph(50) }
  a = LFM::Artist.search("Michael jackson")[0]
  a = Artist.find_or_create_by_name_and_mbid(:name => a.name, :mbid => a.mbid)
  a.graph(50)
end
