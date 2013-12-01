class AddVisitedToArtists < ActiveRecord::Migration
  def change
    add_column :artists, :visited, :boolean
  end
end
