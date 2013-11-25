task :get_missing_artists => :environment do
  #Artist.connection.execute("UPDATE artists SET listenings = NULL")
  while true do
    i=0
    Artist.find(:all, conditions: "listenings is null", order: "listenings DESC", limit: 10).each do |a|
      begin
        if i%2 == 0
          Thread.new { a.graph(1) }
        else
          a.graph(2)
        end
      rescue Exception
      end
      i+=1
    end
  end
end
