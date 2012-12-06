module ActsAsGraph
  module ClassMethods
    def acts_as_graph(options = {})

      mattr_accessor :graph_options
      # define defaults options
      self.graph_options = ActsAsGraph::process_options(self, options)

      #set active record associations
      if self.graph_options[:directed]
        #ActsAsGraph::directed_association(self, self.graph_options)
        has_and_belongs_to_many :parents,
          :class_name              => self.name,
          :join_table              => self.graph_options[:edge_table].to_s,
          :association_foreign_key => self.graph_options[:parent_col].to_s,
          :foreign_key             => self.graph_options[:child_col].to_s

        has_and_belongs_to_many :children,
          :class_name              => self.name,
          :join_table              => self.graph_options[:edge_table].to_s,
          :association_foreign_key => self.graph_options[:child_col].to_s,
          :foreign_key             => self.graph_options[:parent_col].to_s

      else
        #ActsAsGraph::undirected_association(self, self.graph_options)
        finder_sql = proc { "SELECT Child.* 
          FROM #{self.class.table_name} AS Parent 
            INNER JOIN #{self.graph_options[:edge_table]} ON Parent.id = #{self.graph_options[:edge_table]}.#{self.graph_options[:parent_col]} 
            INNER JOIN #{self.class.table_name} AS Child ON Child.id = #{self.graph_options[:edge_table]}.#{self.graph_options[:child_col]} 
          WHERE Parent.id = #{id} 
          UNION 
          SELECT Parent.* 
          FROM #{self.class.table_name} AS Parent 
            INNER JOIN #{self.graph_options[:edge_table]} ON Parent.id = #{self.graph_options[:edge_table]}.#{self.graph_options[:parent_col]} 
            INNER JOIN #{self.class.table_name} AS Child ON Child.id = #{self.graph_options[:edge_table]}.#{self.graph_options[:child_col]} 
          WHERE Child.id = #{id}"}

     has_many :neighbours,
       :class_name             => self.name,
       :finder_sql             => finder_sql,
       :through                => "#{self.name.to_s.underscore}_edges"
      end
    end
  end
  module StingletonMethods #:nodoc:
  end

  module InstanceMethods #:nodoc:
    def dfs(seen = [], node = self, &block) 
      seen << node
      block.call(node)
      node.children.each do |child|
        self.dfs(seen, child, &block) unless seen.include?(child)
      end
    end
  end

  def self.process_options(klass, opts)
    default_opts = {
      :edge_table => "#{klass.name.to_s.underscore}_edges",
      :parent_col => "parent_id",
      :child_col => "child_id",
      :allow_cycle => false,
      :directed => false,
      :child_collection => "children",
      :parent_collection => "parents"
    }

    default_opts.merge!(opts)

    return default_opts
  end

  def self.directed_association(klass, graph_options)
    klass.send :has_and_belongs_to_many, :parents,
      :class_name              => self.name,
      :join_table              => graph_options[:edge_table].to_s,
      :association_foreign_key => graph_options[:parent_col].to_s,
      :foreign_key             => graph_options[:child_col].to_s
    
    klass.send :has_and_belongs_to_many, :children,
      :class_name              => self.name,
      :join_table              => graph_options[:edge_table].to_s,
      :association_foreign_key => graph_options[:child_col].to_s,
      :foreign_key             => graph_options[:parent_col].to_s
    
  end

  def self.undirected_association(klass, graph_options)
    finder_sql = <<-SQL
      SELECT Child.* 
      FROM #{self.table_name} AS Parent 
        INNER JOIN #{graph_options[:edge_table]}
          ON #{self.table_name}.id = #{graph_options[:edge_table]}.#{graph_options[:parent_col]}
        INNER JOIN #{self.table_name} AS Child 
          ON #{self.table_name}.id = #{graph_options[:edge_table]}.#{graph_options[:child_col]}
      WHERE Parent.id = #{self.id}
      UNION
      SELECT Parent.* 
      FROM #{self.table_name} AS Parent 
        INNER JOIN #{graph_options[:edge_table]}
          ON #{self.table_name}.id = #{graph_options[:edge_table]}.#{graph_options[:parent_col]}
        INNER JOIN #{self.table_name} AS Child 
          ON #{self.table_name}.id = #{graph_options[:edge_table]}.#{graph_options[:child_col]}
      WHERE Child.id = #{self.id}
      SQL

      klass.send :has_and_belongs_to_many, :neighbours,
        :class_name             => self.name,
        :finder_sql             => finder_sql
  end
end
  ActiveRecord::Base.send :extend, ActsAsGraph::ClassMethods
  ActiveRecord::Base.send :include, ActsAsGraph::InstanceMethods
