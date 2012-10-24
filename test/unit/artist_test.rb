require 'test_helper'

class ArtistTest < ActiveSupport::TestCase
  fixtures :artists, :artist_edges

  test "directed graphs edges" do
    Artist.respond_to?('graph_options') ? Artist.graph_options[:directed] = true : Artist.send(:acts_as_graph, :directed => true) 

    assert_equal Artist.graph_options[:directed], true, "the graph is undirected"
 
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

  test "undirected graph edges" do
    Artist.respond_to?('graph_options') ? Artist.graph_options[:directed] = false : Artist.send(:acts_as_graph, :directed => false) 

    assert_equal Artist.graph_options[:directed], false, "the graph is directed"
    
    assert_equal [artists(:b),
      artists(:c),
      artists(:d),
      artists(:e)], 
      artists(:a).neighbours, 
      "neighbour relationship"
  end

  test "bad test" do
    assert false, "this is not a test"
  end
end
