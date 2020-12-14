require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]

require 'active_support/all'
require 'zeitwerk'
loader = Zeitwerk::Loader.new
loader.push_dir('lib')
loader.setup