ENV['APP_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/reporters'
require 'mocha/minitest'
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]


require './lib/config/initializer'
ActiveRecord::Migration.maintain_test_schema!

require 'active_support/test_case'
ActiveSupport.test_order = :random


require 'zeitwerk'
loader = Zeitwerk::Loader.new
# loader.push_dir('test/common')
# loader.push_dir('test/application')
# loader.push_dir('test/infrastructure/persistence')

loader.setup