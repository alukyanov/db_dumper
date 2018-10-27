module DbDumper
  class QueryBuilder
    class Query
      attr_reader :table, :ar

      delegate :table_name, to: :table

      def initialize(table)
        @table  = table
        @ar     = @table.ar.all
      end

      def where(*args)
        tap { @ar = @ar.where(*args) }
      end

      def joins(*args)
        raise 'Only simple string for joins supported' unless args.size == 1 && args[0].is_a?(String)
        tap { @ar = @ar.joins(*args) }
      end

      def select(*args)
        tap { @ar = @ar.select(*args) }
      end

      def to_sql
        @ar.to_sql
      end
    end
  end
end
