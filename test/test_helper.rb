ENV['APP_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]

require 'active_support/all'
require 'active_support/test_case'
ActiveSupport.test_order = :random

require 'zeitwerk'
loader = Zeitwerk::Loader.new

loader.push_dir('lib/common')
loader.push_dir('lib/common/domain')
loader.push_dir('lib/common/event')
loader.push_dir('lib/common/notification')

loader.push_dir('lib/domain')
loader.push_dir('lib/domain/access')
loader.push_dir('lib/domain/identity')
loader.push_dir('lib/infrastructure/services')
loader.push_dir('lib/application')
loader.push_dir('lib/application/command')
loader.push_dir('lib/resource')

loader.push_dir('test/common')
loader.push_dir('test/application')
loader.push_dir('test/infrastructure/persistence')

loader.setup