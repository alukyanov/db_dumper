# DB dumper - configurable SQL database data copying util from remote to local machine.

[![Gem Version](https://badge.fury.io/rb/db_dumper.svg)](https://badge.fury.io/rb/db_dumper)
[![Maintainability](https://api.codeclimate.com/v1/badges/d5676f2dca807bdc458b/maintainability)](https://codeclimate.com/github/alukyanov/db_dumper/maintainability)
[![Build Status](https://travis-ci.org/alukyanov/db_dumper.svg?branch=master)](https://travis-ci.org/alukyanov/db_dumper)

## Index
- [Usage](#usage)
- [Config](#config)
- [Installation](#installation)
  - [Manually from RubyGems.org](#manually-from-rubygemsorg)
  - [Bundler](#or-if-you-are-using-bundler)

## Usage
- Setup config/application.yml file properly.
- Install pg_dump, psql utils on remote machine for PostgreSQL adapter.

Example for simple Ruby file:

```ruby

require 'rubygems/package'
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'db_dumper'
end

DbDumper.dump do
  dump 'roles'

  user_id = 1
  copy q('users').where(id: user_id)
  campaigns_q = q('campaigns').where('user_id = ? OR for_all IS TRUE', user_id)
  copy campaigns_q
  copy q('offices').where(campaign_id: campaigns_q.ar)
end
```

After executing you will see:
- schema sql at local_machine/dest_path/schema_dump.sql.
- csv files at local_machine/dest_path/csv/*.csv
 

### Config

#### remote_db
##### adapter
Currently supported only postgres adapter, so you can dump only PostgreSQL.

Config file example at config/application.yml

```
remote_db:
  adapter: postgres
  host: host
  port: 5432
  database: dockerdb
  username: docker
  password: pass

remote_user:
  name: docker
  host: beta.staging.com
  ssh_keys: ['/.ssh/docker']
  passphrase: pass

remote_machine:
  dest_path: /tmp

local_machine:
  dest_path: /tmp
```

## <a id="installation">Installation ##

### Manually from RubyGems.org ###

```sh
% gem install db_dumper
```

### Or if you are using Bundler ###

```ruby
# Gemfile
gem 'db_dumper'
```

## Latest changes ##

Take a look at the [CHANGELOG](https://github.com/alukyanov/db_dumper/blob/master/CHANGELOG.md) for details about recent changes to the current version.

## Questions? ##

Feel free to

* [create an issue on GitHub](https://github.com/alukyanov/db_dumper/issues)

## Maintainers ##

* [Alexey Lukyanov](https://github.com/alukyanov)

## Warranty ##

This software is provided "as is" and without any express or
implied warranties, including, without limitation, the implied
warranties of merchantibility and fitness for a particular
purpose.

## License ##

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
