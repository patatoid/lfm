require 'test_helper'

class Node < ActiveRecord::Base
end

class DirectedGraphNode < Node 
  acts_as_graph :directed => true
end

class UndirectedGraphNode < Node
  acts_as_graph :directed => false
end


class GraphTest < ActiveSupport::TestCase
  fixtures :directed_graph_nodes, :edges

  test "directed graphs edges" do
    assert_equal [directed_graph_nodes(:b),
      directed_graph_nodes(:c),
      directed_graph_nodes(:d),
      directed_graph_nodes(:e)], 
      directed_graph_nodes(:a).children, 
      "children relationship"
    assert_equal [directed_graph_nodes(:a),
      directed_graph_nodes(:b),
      directed_graph_nodes(:c),
      directed_graph_nodes(:d)], 
      directed_graph_nodes(:e).parents, 
      "parents relationship"
  end

  test "undirected graph edges" do
    assert_equal [undirected_graph_nodes(:b),
      undirected_graph_nodes(:c),
      undirected_graph_nodes(:d),
      undirected_graph_nodes(:e)], 
      undirected_graph_nodes(:a).neighbours, 
      "neighbour relationship"
  end
end
