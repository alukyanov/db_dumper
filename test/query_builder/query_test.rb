# frozen_string_literal: true

require 'minitest/autorun'
require 'db_dumper/query_builder/query'

class QueryTest < ActiveSupport::TestCase
  def setup
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
    @query = DbDumper::QueryBuilder::Query.new('users')
    sleep(0.1) # HACK sqlite table sometimes not created :)
  end

  def test_initialize
    assert_equal(@query.table_name, 'users')
  end

  def test_where
    assert_equal @query.where(job: 'dev').to_sql,
                 "SELECT \"users\".* FROM \"users\" WHERE \"users\".\"job\" = 'dev'"
  end

  def test_joins
    assert_equal @query.joins('left outer join campaigns on users.id = campaigns.user_id').to_sql,
                 "SELECT \"users\".* FROM \"users\" left outer join campaigns on users.id = campaigns.user_id"
  end

  def test_select
    assert_equal @query.select(:id, :name).to_sql,
                 "SELECT \"users\".\"id\", \"name\" FROM \"users\""
  end

  def test_complex
    assert_equal @query
                   .joins('left outer join campaigns on users.id = campaigns.user_id')
                   .where(job: 'dev').select(:id, :name).to_sql,
                 "SELECT \"users\".\"id\", \"name\" FROM \"users\" left outer join campaigns on users.id = campaigns.user_id WHERE \"users\".\"job\" = 'dev'"
  end
end
