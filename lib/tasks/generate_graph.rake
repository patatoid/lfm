task :generate_graph => :environment do
  a = LFM::Artist.get_correction("Portishead")
  a = Artist.create(:name => a.name, :mbid => a.mbid)
  a.graph(100, 100)
end
