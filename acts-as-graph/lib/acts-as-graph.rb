module ActsAsGraph
	extend ActiveSupport::Concern

	included do
	end

	module ClassMethods
		def acts_as_graph(options = {})
		
			# define defaults options
			ActsAsGraph::process_options(self, options)
		end
	end

	def process_options(klass, opts)
		defaults_opts = {
			:edge_table => "#{klass.name.to_s.underscore.pluralize}_edges",
			:parent_col => "parent_id",
			:child_col => "child_id",
			:allow_cycle => false,
			:directed => true,
			:child_collection => "children",
			:parent_collection => "parents"
		}

		opts = default_opts.merge(opts)

	end
	module SingletonMethods #:nodoc:
	end

	module InstanceMethods #:nodoc:
	end
end

ActiveRecord::Base.send :include, "ActsAsGraph"
