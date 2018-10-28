require_relative 'remote_machine/ssh_agent'

module DbDumper
  class RemoteMachine
    attr_reader :config, :copy_commands_sql

    def initialize(config, copy_commands_sql)
      @config = config
      @copy_commands_sql = copy_commands_sql
    end

    def dump
      config.log('save sql commands to local machine')
      save_commands_sql_to_tmp_file

      with_ssh do |ssh|
        upload_commands_sql_to_remote_machine(ssh)

        dump_schema(ssh)
        dump_data(ssh)

        download_schema(ssh)
        download_data(ssh)

        clean(ssh)
      end
    end

    private

    def with_ssh
      ssh_agent = SshAgent.new(config)
      yield(ssh_agent)
    end

    def save_commands_sql_to_tmp_file
      File.open(local_commands_sql_file_path, 'w') do |file|
        file.write(copy_commands_sql)
      end
    end

    def upload_commands_sql_to_remote_machine(ssh)
      ssh.upload!(local_commands_sql_file_path, remote_commands_sql_file_path)
    end

    def dump_schema(ssh)
      ssh.exec!(db_utils.dump_schema_command(remote_machine_schema_file_path))
    end

    def dump_data(ssh)
      ssh.exec!("mkdir -p #{remote_machine_data_path}")
      ssh.exec!(db_utils.dump_data_command(remote_commands_sql_file_path))
    end

    def download_schema(ssh)
      ssh.download!(remote_machine_schema_file_path, dest_path)
    end

    def download_data(ssh)
      ssh.download!(remote_machine_data_path, dest_path, recursive: true)
    end

    def clean(ssh)
      ssh.exec! "rm #{remote_commands_sql_file_path}"
      ssh.exec! "rm #{remote_machine_schema_file_path}"
      ssh.exec! "rm -rf #{remote_machine_data_path}"

      File.delete(local_commands_sql_file_path)
    end

    def db_utils
      config.db_utils
    end

    def remote_machine_schema_file_path
      "#{remote_machine_dest_path}/#{dump_schema_fname}"
    end

    def remote_commands_sql_file_path
      "#{remote_machine_dest_path}/#{commands_sql_fname}"
    end

    def local_commands_sql_file_path
      "#{dest_path}/#{commands_sql_fname}"
    end

    def remote_machine_data_path
      config.remote_machine.data_path
    end

    def remote_machine_dest_path
      config.remote_machine.dest_path
    end

    def dest_path
      config.local_machine.dest_path
    end

    def commands_sql_fname
      @commands_sql_fname ||= "#{Digest::MD5.hexdigest(copy_commands_sql)}.sql"
    end

    def dump_schema_fname
      'schema_dump.sql'
    end
  end
end
