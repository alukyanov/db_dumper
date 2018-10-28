require 'sqlite3'
require 'active_record'

module DbDumper
  class QueryBuilder

    # Storage for generated classes inherited from ActiveRecord::Base
    class Table
      attr_reader :table_name

      @tables = {}

      def self.from(raw_table)
        return raw_table if raw_table.is_a?(Table)

        table_name_str = raw_table.to_s
        @tables[table_name_str] ||= new(table_name_str)
      end

      def ar
        @ar ||= Class.new(ActiveRecord::Base).tap do |klass|
          klass.table_name = table_name
        end
      end

      private

      def initialize(table_name)
        @table_name = table_name
        create_table
      end

      def create_table
        ActiveRecord::Migration.create_table(table_name)
      end
    end
  end
end
