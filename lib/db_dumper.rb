# frozen_string_literal: true

require 'yaml'

require 'net/ssh'
require 'net/scp'
require 'active_record'

require_relative 'db_dumper/configuration'
require_relative 'db_dumper/query_builder'
require_relative 'db_dumper/remote_machine'

module DbDumper
  module_function def dump(config_file_path = 'config/dumper.yml', dest = 'tmp', &block)
    config = Configuration.new(config_file_path)
    query = QueryBuilder.build(config, &block)

    RemoteMachine.new(config, dest, query.dumping_tables, query.copy_commands).dump
  end
end
