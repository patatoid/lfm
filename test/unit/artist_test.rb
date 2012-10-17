require 'test_helper'

class ArtistTest < ActiveSupport::TestCase
  fixtures :artists, :artist_edges

  test "directed graphs edges" do
    Artist.graph_options ? Artist.send(:acts_as_graph) : Artist.graph_options[:directed] = true
     assert_equal [artists(:b),
                  artists(:c),
                  artists(:d),
                  artists(:e)], 
                artists(:a).children, 
                "children relationship"
    assert_equal [artists(:a),
                  artists(:b),
                  artists(:c),
                  artists(:d)], 
                artists(:e).parents, 
                "parents relationship"
    
  end

  test "bad test" do
    assert false, "this is not a test"
  end
end
