require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['test/**/*_test.rb']
end

task default: :test

require './lib/config/initializer'
require 'sinatra/activerecord/rake'