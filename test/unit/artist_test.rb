require 'test_helper'

class ArtistTest < ActiveSupport::TestCase
  fixtures :artists, :artist_edges

  test "directed graphs edges" do
    Artist.send "acts_as_graph"
    assert_equal [artists(:b),
                  artists(:c),
                  artists(:d),
                  artists(:e)], 
                artists(:a).children, 
                "bad directed edges definition"
  end

  test "bad test" do
    assert false, "this is not a test"
  end
end
