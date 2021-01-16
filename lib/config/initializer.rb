# Sinatra Base
require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/activerecord'

# Database
set :database_file, 'database.yml'

# Active Support
require 'active_support/all'

# Load files
require 'zeitwerk'
loader = Zeitwerk::Loader.new
loader.push_dir('lib/common')
loader.push_dir('lib/common/domain')
loader.push_dir('lib/common/event')
loader.push_dir('lib/common/notification')
loader.push_dir('lib/common/port/adapter/persistence')
loader.push_dir('lib/domain')
loader.push_dir('lib/domain/access')
loader.push_dir('lib/domain/identity')
loader.push_dir('lib/infrastructure/services')
loader.push_dir('lib/application')
loader.push_dir('lib/application/command')
loader.push_dir('lib/application/representation')
loader.push_dir('lib/resource')
loader.push_dir('lib/infrastructure/persistence')


loader.push_dir('test/application')

loader.setup