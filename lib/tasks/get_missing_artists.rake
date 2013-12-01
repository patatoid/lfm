task :get_missing_artists => :environment do
  while true do
    i=0
    Artist.find(:all, conditions: "NOT EXISTS (select * from artist_edges where parent_id = artists.id)", order: "listenings DESC", limit: 5).each do |a|
        if i%5 == 4
          a.graph(1)
        else
          Thread.new { a.graph(1) }
        end
      i+=1
    end
  end
end
