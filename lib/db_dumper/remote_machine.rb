module DbDumper
  class RemoteMachine
    attr_reader :config, :sql

    def initialize(config, sql)
      @config = config
      @sql    = sql
    end

    def dump
      config.log('save sql commands to local machine')
      save_commands_sql_to_tmp_file

      Net::SSH.start(*ssh_credentials) do |ssh|
        config.log('upload commands to remote machine')
        upload_commands_sql_to_remote_machine(ssh)

        config.log('dump schema on remote machine')
        dump_schema(ssh)

        config.log('dump data on remote machine')
        dump_data(ssh)

        config.log('download schema to local machine')
        download_schema(ssh)

        config.log('download data to local machine')
        download_data(ssh)

        config.log('clean remote machine')
        clean_remote_machine(ssh)
      end
    end

    private

    # Upload
    def save_commands_sql_to_tmp_file
      File.open(local_commands_sql_file_path, 'w') { |f| f.write(sql) }
    end

    def upload_commands_sql_to_remote_machine(ssh)
      ssh.scp.upload!(local_commands_sql_file_path, remote_commands_sql_file_path)
      File.delete(local_commands_sql_file_path)
    end

    def remote_commands_sql_file_path
      "#{remote_machine_dest_path}/#{commands_sql_fname}"
    end

    def local_commands_sql_file_path
      "#{dest_path}/#{commands_sql_fname}"
    end

    def commands_sql_fname
      @commands_sql_fname ||= "#{Digest::MD5.hexdigest(sql)}.sql"
    end

    # Schema

    def dump_schema(ssh)
      ssh.exec! db_utils.dump_schema_command(remote_machine_schema_file_path)
    end

    def download_schema(ssh)
      ssh.scp.download!(remote_machine_schema_file_path, dest_path)
    end

    def remote_machine_schema_file_path
      "#{remote_machine_dest_path}/#{dump_schema_fname}"
    end

    def dump_schema_fname
      'schema_dump.sql'
    end

    # Data

    def dump_data(ssh)
      ssh.exec!("mkdir -p #{remote_machine_data_path}")
      ssh.exec! db_utils.dump_data_command(remote_commands_sql_file_path)
    end

    def download_data(ssh)
      ssh.scp.download!(remote_machine_data_path, dest_path, recursive: true)
    end

    def clean_remote_machine(ssh)
      ssh.exec! "rm #{remote_commands_sql_file_path}"
      ssh.exec! "rm #{remote_machine_schema_file_path}"
      ssh.exec! "rm -rf #{remote_machine_data_path}"
    end

    #

    def db_utils
      config.db_utils
    end

    def remote_machine_dest_path
      config.remote_machine.dest_path
    end

    def remote_machine_data_path
      config.remote_machine.data_path
    end

    def ssh_credentials
      [
        ssh_user.host,
        ssh_user.name,
        keys:       ssh_user.ssh_keys,
        passphrase: ssh_user.passphrase
      ]
    end

    def ssh_user
      config.ssh_user
    end

    def dest_path
      config.local_machine.dest_path
    end
  end
end
