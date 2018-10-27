require_relative 'query_builder/table'
require_relative 'query_builder/query'

module DbDumper
  class QueryBuilder
    attr_reader :config

    def self.to_sql(config, &block)
      establish_connection

      instance = new(config)
      instance.instance_eval(&block)
      instance.to_sql
    end

    def initialize(config)
      @config = config
    end

    def self.establish_connection
      return if ActiveRecord::Base.connected?

      ActiveRecord::Migration.verbose = false
      ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
    end

    def dump(query)
      query = q(query) if query.is_a?(String)
      query.tap { |q| queries << q }
    end

    def q(table_name)
      Query.new Table.from(table_name.to_s)
    end

    def to_sql
      queries.map do |query|
        "\\COPY (#{query.to_sql}) TO '#{copy_path}/#{query.table_name}.csv';"
      end.join($RS)
    end

    private

    def queries
      @queries ||= []
    end

    def copy_path
      config.remote_machine.dest_path
    end
  end
end
