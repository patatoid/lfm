task :generate_graph => :environment do
  Artist.connection.execute(sanitize_sql("UPDATE artists SET listenings = NULL"))
  a = LFM::Artist.search("portishead")
  a = Artist.find_or_create_by_name_and_mbid(:name => a.name, :mbid => a.mbid)
  a.graph(1000)
end
