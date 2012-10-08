class ActsAsGraphGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
	def create_edge_model
		template "edge.rb.erb", "app/models/edge.rb"
	end

  def create_migration
    template "CreateEdges.rb.erb", "db/migrate/#{Time::now.strftime("%Y%m%d%H%M%S")}_create_edges.rb"
  end
end

