$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'db_dumper/version'

Gem::Specification.new do |s|
  s.name        = 'db_dumper'
  s.version     = DbDumper::VERSION
  s.date        = Time.now
  s.summary     = 'Dump database schema and chosen data from remote machine'
  s.description = 'Dump database schema and chosen data from remote machine'
  s.homepage    = 'http://rubygems.org/gems/db_dumper'
  s.authors     = ['Alexey Lukyanov']
  s.email       = 'alukyanov.dev@gmail.com'
  s.licenses    = ['MIT']

  s.metadata = {
    'bug_tracker_uri'   => 'https://github.com/alukyanov/db_dumper/issues',
    'changelog_uri'     => 'https://github.com/alukyanov/db_dumper/CHANGELOG.md',
    'documentation_uri' => "http://www.rubydoc.info/gems/db_dumper/#{DbDumper::VERSION}",
    'homepage_uri'      => 'https://github.com/alukyanov/db_dumper',
    'source_code_uri'   => 'https://github.com/alukyanov/db_dumper',
    'wiki_uri'          => 'https://github.com/alukyanov/db_dumper/wiki'
  }

  s.platform              = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'activerecord', '~> 5.2', '>= 5.2.1'
  s.add_dependency 'net-scp'
  s.add_dependency 'net-ssh'
  s.add_dependency 'sqlite3'

  s.add_development_dependency 'bundler', '~> 1.16'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'minitest', '~> 5.0'

  s.files         = Dir['README.md', 'CHANGELOG.md', 'lib/**/*']
  s.require_path  = 'lib'
end
