# frozen_string_literal: true

require_relative 'configuration/base'
require_relative 'configuration/postgres'

module DbDumper

  # Configuration class, by default loads from config/application.yml file
  # see config/application.sample.yml for format details
  class Configuration
    SshUser = Struct.new(:name, :host, :ssh_keys, :passphrase, keyword_init: true)
    RemoteDB = Struct.new(:adapter, :host, :port, :database, :username, :password,
                          :dump_schema_options, :dump_data_options,
                          keyword_init: true)
    RemoteMachine = Struct.new(:dest_path, keyword_init: true) do
      def data_path
        "#{dest_path}/csv"
      end
    end
    LocalMachine = Struct.new(:dest_path, keyword_init: true)

    DB_UTILS = {
      'postgres' => Postgres
    }

    attr_reader :config_file_path

    def initialize(config_file_path)
      @config_file_path = config_file_path
    end

    def log(message)
      logger.info(message)
    end

    def db_utils
      @db_utils ||= begin
        utils = DB_UTILS[remote_db.adapter]
        raise 'Unknown adapter for remote_db:adapter check application.yml' unless utils
        utils.new(remote_db)
      end
    end

    def ssh_user
      @ssh_user ||= SshUser.new(loaded_file['ssh_user'])
    end

    def remote_machine
      @remote_machine ||= RemoteMachine.new(loaded_file['remote_machine'])
    end

    def remote_db
      @remote_db ||= RemoteDB.new(loaded_file['remote_db'])
    end

    def local_machine
      @local_machine ||= LocalMachine.new(loaded_file['local_machine'])
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    private

    def loaded_file
      @loaded_file ||= YAML.load_file(config_file_path)
    end
  end
end
