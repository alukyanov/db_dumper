# frozen_string_literal: true

require 'yaml'

require 'net/ssh'
require 'net/scp'
require 'active_record'

require_relative 'db_dumper/configuration'
require_relative 'db_dumper/query_builder'
require_relative 'db_dumper/remote_machine'

module DbDumper
  module_function def dump(config_file_path = 'config/application.yml', &block)
    config = Configuration.new(config_file_path)
    sql = QueryBuilder.to_sql(config, &block)
    RemoteMachine.new(config, sql).dump
  end
end
