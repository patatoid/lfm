task :get_listenings => :environment do
  i=0
  Artist.where("listenings IS NULL").each do |artist|
    lfm_artist = LFM::Artist.new(:name => artist.name)
    p lfm_artist
    begin
    if i%4 == 3
      artist.update_attributes(:listenings => lfm_artist.listenings)
    else
      Thread.new { artist.update_attributes(:listenings => lfm_artist.listenings) }
    end
    rescue Exception
    end
    i+=1
    i=0 if i == 5000
  end
end
