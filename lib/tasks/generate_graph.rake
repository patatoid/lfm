task :generate_graph => :environment do
  unless Artist.all.any?
    a = LFM::Artist.get_correction("Portishead")
    a = Artist.create(:name => a.name, :mbid => a.mbid)
  end
  Artist.where(visited: nil).each do |a|
    a.graph(2, 10)
  end
end
