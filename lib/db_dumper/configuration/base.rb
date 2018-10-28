module DbDumper
  class Configuration
    class Base
      attr_reader :db_config

      def initialize(db_config)
        @db_config = db_config
      end

      def copy_data_command(sql, file_path)
        raise NotImplementedError
      end

      def dump_schema_command(dump_schema_file_path)
        raise NotImplementedError
      end

      def dump_data_command(dump_data_file_path)
        raise NotImplementedError
      end
    end
  end
end
