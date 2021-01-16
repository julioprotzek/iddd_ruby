class AbstractJsonResource < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  before do
    content_type :json
  end

  def access_application_service
    ApplicationServiceRegistry.access_application_service
  end

  def identity_application_service
    ApplicationServiceRegistry.identity_application_service
  end

  def notification_application_service
    ApplicationServiceRegistry.notification_application_service
  end
end