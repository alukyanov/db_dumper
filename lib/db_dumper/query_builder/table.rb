module DbDumper
  class QueryBuilder
    class Table
      attr_reader :table_name

      @tables = {}

      def self.from(table_name)
        @tables[table_name] ||= begin
          ActiveRecord::Migration.create_table(table_name)
          new(table_name)
        end
      end

      def ar
        @ar ||= Class.new(ActiveRecord::Base).tap do |klass|
          klass.table_name = table_name
        end
      end

      private

      def initialize(table_name)
        @table_name = table_name
      end
    end
  end
end
