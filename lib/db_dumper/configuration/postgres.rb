module DbDumper
  class Configuration
    class Postgres < Base
      def copy_data_command(sql, file_path)
        "\\COPY (#{sql}) TO '#{file_path}';"
      end

      def dump_schema_command(dump_schema_file_path)
        util_command('pg_dump', "#{db_config.dump_schema_options} -f #{dump_schema_file_path}")
      end

      def dump_data_command(dump_data_file_path)
        util_command('psql', "#{db_config.dump_data_options} -f #{dump_data_file_path}")
      end

      private

      def util_command(util, command)
        <<-CMD.squish
          PGPASSWORD=#{db_config.password} #{util}
            -h #{db_config.host}
            -p #{db_config.port}
            -U #{db_config.username}
            -d #{db_config.database}
          #{command}
        CMD
      end
    end
  end
end
