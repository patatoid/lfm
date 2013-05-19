class Indices < ActiveRecord::Migration
  def up
    add_index "artists", "listenings"
    add_index "artist_edges", "parent_id"
    add_index "artist_edges", "child_id"
  end

  def down
    remove_index "artists", "listenings"
    remove_index "artist_edges", "parent_id"
    remove_index "artist_edges", "child_id"
  end
end
