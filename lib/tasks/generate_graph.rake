task :generate_graph => :environment do
  a = LFM::Artist.get_correction("Portishead")
  a = Artist.find_or_create_by_name_and_mbid(:name => a.name, :mbid => a.mbid)
  a.graph(100, 100)
end
