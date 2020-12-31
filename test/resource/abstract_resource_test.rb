require 'sinatra/base'
require 'sinatra/reloader'
require 'rack/test'
require './test/application/application_service_test'
require './lib/identity_and_access'

class AbstractResourceTest < ApplicationServiceTest
  include Rack::Test::Methods

  def app
    IdentityAndAccess
  end

  def json_response
    JSON.parse(last_response.body).deep_symbolize_keys
  rescue StandardError
    pp "Expected valid json"
    pp last_response.body
  end

  def url_encode(string)
    ERB::Util.url_encode(string)
  end
end