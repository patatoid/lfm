class ArtistEdge < ActiveRecord::Base
  belongs_to :parent, :class_name => :artist
  belongs_to :child, :class_name => :artist

  attr_accessible :parent_id, :child_id, :weight
end
