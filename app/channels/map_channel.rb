class MapChannel < ActionCable::Channel::Base
  def subscribed
    stream_from 'artist_map'

    def bfs(node, depth)
      return unless depth > 0
      sleep(0.25)
      node.get_similar(10).each do |similarity, artist|
        sleep(0.2)
        ActionCable.server.broadcast 'artist_map',
          [node.to_json, {similarity => artist.to_json.merge(listenings: artist.listenings)}]
        begin
          bfs(artist, depth - 1)
        rescue
        end
      end
    end

    # root = LFM::Artist.get_correction('selah sue')
    # bfs(root, 2)
  end
end
