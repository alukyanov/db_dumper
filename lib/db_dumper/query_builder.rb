require_relative 'query_builder/table'
require_relative 'query_builder/query'

module DbDumper
  # Generates queries for copying data
  class QueryBuilder
    attr_reader :config

    def self.build(config, &block)
      establish_connection

      new(config).tap do |instance|
        instance.instance_eval(&block)
      end
    end

    def dumping_tables
      @dumping_tables ||= []
    end

    def copy_commands
      queries.map(&method(:build_copy_command))
    end

    # DSL start

    # Dump whole table to sql file
    def dump(table_name)
      dumping_tables << table_name
    end

    # add query to current dump
    def copy(query)
      queries << query
    end

    # creates new query
    def q(raw_table)
      Query.new(raw_table)
    end

    # DSL end

    def self.establish_connection
      return if ActiveRecord::Base.connected?

      ActiveRecord::Migration.verbose = false
      ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
    end
    private_class_method :establish_connection

    private

    def initialize(config)
      @config = config
    end

    def queries
      @queries ||= []
    end

    def build_copy_command(query)
      config.db_utils.copy_data_command(query.to_sql, "#{copy_path}/#{query.table_name}.csv")
    end

    def copy_path
      config.remote_machine.data_path
    end
  end
end
