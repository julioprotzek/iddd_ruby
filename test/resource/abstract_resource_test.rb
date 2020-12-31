require './test/application/application_service_test'
require 'rack/test'

class AbstractResourceTest < ApplicationServiceTest
  include Rack::Test::Methods

  def app
    IdentityAndAccessApp
  end

  def json_response
    JSON.parse(last_response.body).deep_symbolize_keys
  end

  def url_encode(string)
    ERB::Util.url_encode(string)
  end
end