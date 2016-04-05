require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'neo4j/railtie'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test production)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module LFMConstellation
  class Application < Rails::Application
    config.autoload_paths += %W(#{config.root}/lib)

    # neo4j
    config.generators { |g| g.orm :neo4j }
    config.neo4j.session_type = :server_db
    config.neo4j.session_path = ENV['GRAPHSTORY_URL'] || 'http://localhost:7474'

    # background jobs
    config.active_job.queue_adapter = :sidekiq
  end
end
