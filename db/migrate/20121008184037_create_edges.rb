class CreateEdges < ActiveRecord::Migration
  def up
    create_table :artist_edges, :id => false do |t|
      t.integer :parent_id
      t.integer :child_id
      t.float :weight
    end

    if connection.adapter_name == 'MySQL'
      execute <<-SQL
      ALTER TABLE artist_edges
        ADD CONSTRAINT fk_source
        FOREIGN KEY (parent_id)
        REFERENCES artist(id)
      SQL

      execute <<-SQL
      ALTER TABLE artist_edges
        ADD CONSTRAINT fk_destination
        FOREIGN KEY (parent_id)
        REFERENCES artist(id)
      SQL
    end
  end

  def down
    if connection.adapter_name == 'MySQL'
      execute <<-SQL
      ALTER TABLE artist_edges
        DROP FOREIGN KEY fk_source
      SQL

      execute <<-SQL
      ALTER TABLE artist_edges
        DROP FOREIGN KEY fk_destination
      SQL
    end
    drop_table :artist
  end
end
