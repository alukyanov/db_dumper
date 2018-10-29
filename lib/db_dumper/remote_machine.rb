require_relative 'remote_machine/ssh_agent'

module DbDumper
  class RemoteMachine
    attr_reader :config, :dumped_tables, :copy_commands

    def initialize(config, dumped_tables, copy_commands)
      @config = config
      @dumped_tables = dumped_tables
      @copy_commands = copy_commands
    end

    def dump
      with_ssh do |ssh|
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

    def dump_schema(ssh)
      ssh.exec!(db_utils.dump_schema_command(remote_machine_schema_file_path))
    end

    def dump_data(ssh)
      ssh.exec!("mkdir -p #{remote_machine_data_path}")

      ssh.exec!(db_utils.dump_table_data_command(dumped_tables, remote_machine_tables_data_file_path))
      copy_commands.each do |copy_command|
        ssh.exec!(db_utils.dump_data_command(copy_command))
      end
    end

    def download_schema(ssh)
      ssh.download!(remote_machine_schema_file_path, dest_path)
    end

    def download_data(ssh)
      ssh.download!(remote_machine_data_path, dest_path, recursive: true)
      ssh.download!(remote_machine_tables_data_file_path, dest_path)
    end

    def clean(ssh)
      ssh.exec! "rm #{remote_machine_schema_file_path}"
      ssh.exec! "rm #{remote_machine_tables_data_file_path}"
      ssh.exec! "rm -rf #{remote_machine_data_path}"
    end

    def db_utils
      config.db_utils
    end

    def remote_machine_schema_file_path
      "#{remote_machine_dest_path}/#{dump_schema_fname}"
    end

    def remote_machine_tables_data_file_path
      "#{remote_machine_dest_path}/#{dump_data_fname}"
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

    def dump_schema_fname
      'schema_dump.sql'
    end

    def dump_data_fname
      'data_dump.sql'
    end
  end
end
