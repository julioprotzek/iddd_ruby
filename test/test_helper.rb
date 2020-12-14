require  'minitest/autorun'
require 'active_support/all'
require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]

require './src/full_name'