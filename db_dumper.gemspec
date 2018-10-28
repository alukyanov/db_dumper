$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'db_dumper/version'

Gem::Specification.new do |s|
  s.name        = 'db_dumper'
  s.version     = DbDumper::VERSION
  s.date        = Time.now
  s.summary     = 'Dump database schema and chosen data from remote machine'
  s.description = 'Dump database schema and chosen data from remote machine'
  s.homepage    = 'https://github.com/alukyanov/dumper'
  s.authors     = ['Alexey Lukyanov']
  s.email       = 'alukyanov.dev@gmail.com'
  s.homepage    = 'http://rubygems.org/gems/db_dumper'
  s.licenses    = ['MIT']
  s.platform              = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'activerecord', '~> 5.2', '>= 5.2.1'
  s.add_dependency 'sqlite3'
  s.add_dependency 'pg'
  s.add_dependency 'net-ssh'
  s.add_dependency 'net-scp'

  s.files         = Dir['README.md', 'lib/**/*']
  s.require_path  = 'lib'
end
