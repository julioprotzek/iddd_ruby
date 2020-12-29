require 'sinatra/base'
require 'sinatra/reloader'

class MainApplication < AbstractResource
  use GroupResource

  get '/' do
    "Hello world"
  end
end