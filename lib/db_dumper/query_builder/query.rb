module DbDumper
  class QueryBuilder

    # Wrapper under ActiveRecord::Relation
    class Query
      attr_reader :table, :ar

      delegate :table_name, to: :table

      def initialize(raw_table, exist_ar = nil)
        @table  = Table.from(raw_table)
        @ar     = exist_ar || table.ar.all
      end

      def where(*args)
        self.class.new(table, ar.where(*args))
      end

      def joins(*args)
        raise 'Only simple string for joins supported' unless args.size == 1 && args[0].is_a?(String)
        self.class.new(table, ar.joins(*args))
      end

      def select(*args)
        self.class.new(table, ar.select(*args))
      end

      def to_sql
        @ar.to_sql
      end
    end
  end
end
