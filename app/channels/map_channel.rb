class MapChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'artist_map'
  end

end
