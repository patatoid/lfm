module ActsAsGraph
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    def acts_as_graph(options = {})

      # define defaults options
      mattr_accessor :options
      self.options = ActsAsGraph::process_options(self, options)

      #habtm relation for parent and children collections
      has_and_belongs_to_many :parents,
        :class_name              => self.name,
        :join_table              => self.options[:edge_table].to_s,
        :association_foreign_key => self.options[:parent_col].to_s,
        :foreign_key             => self.options[:child_col].to_s

      has_and_belongs_to_many :children,
        :class_name              => self.name,
        :join_table              => self.options[:edge_table].to_s,
        :association_foreign_key => self.options[:child_col].to_s,
        :foreign_key             => self.options[:parent_col].to_s

    end
  end

  def self.process_options(klass, opts)
    default_opts = {
      :edge_table => "#{klass.name.to_s.underscore}_edges",
      :parent_col => "parent_id",
      :child_col => "child_id",
      :allow_cycle => false,
      :directed => true,
      :child_collection => "children",
      :parent_collection => "parents"
    }

    return default_opts.merge(opts)
  end

  module SingletonMethods #:nodoc:
  end

  module InstanceMethods #:nodoc:
  end
end
ActiveRecord::Base.send :include, ActsAsGraph
