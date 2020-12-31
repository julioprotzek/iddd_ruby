require 'sinatra/base'
require 'sinatra/reloader'

class IdentityAndAccessApp < AbstractResource
  use GroupResource

  get '/' do
    "Api only for now..."
  end
end