class AddEdgesId < ActiveRecord::Migration
  def up
    add_column :artist_edges, :id, :primary_key
  end

  def down
    remove_column :artist_edges, :id
  end
end
