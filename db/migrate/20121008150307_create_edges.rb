class CreateEdges < ActiveRecord::Migration
  def up
    create_table :artists_edges do |t|
      t.integer :parent_id
      t.integer :child_id
      t.float :weight
    end

    if connection.adapter_name == 'MySQL'
      execute <<-SQL
      ALTER TABLE artists_edges
        ADD CONSTRAINT fk_source
        FOREIGN KEY (parent_id)
        REFERENCES artists(id)
      SQL

      execute <<-SQL
      ALTER TABLE artists_edges
        ADD CONSTRAINT fk_destination
        FOREIGN KEY (parent_id)
        REFERENCES artists(id)
      SQL
    end
  end

  def down
    if ActiveRecord::Base.connection.adapter_name == 'MySQL'
      execute <<-SQL
      ALTER TABLE artists_edges
        DROP FOREIGN KEY fk_source
      SQL

      execute <<-SQL
      ALTER TABLE artists_edges
        DROP FOREIGN KEY fk_destination
      SQL
    end
    drop_table :artists
  end
end
