class Artist < ActiveRecord::Base
  attr_accessible :listenings, :mbid, :name, :url
end
