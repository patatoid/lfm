task :get_listenings => :environment do
  Artist.where("listenings IS NULL").each do |artist|
    lfm_artist = LFM::Artist.new(:name => artist.name)
    artist.update_attributes(:listenings => lfm_artist.listenings)
  end
end
