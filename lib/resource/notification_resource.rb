class NotificationResource < AbstractJsonResource
  get '/notifications' do
    current_notification_log = notification_application_service.current_notification_log

    if current_notification_log.present?
      current_notification_log.to_json
    else
      halt 404, {
        error: "Notification log not found"
      }.to_json
    end
  end

  get '/notifications/:notification_log_id' do
    notification_log = notification_application_service.notification_log(params[:notification_log_id])

    if notification_log.present?
      notification_log.to_json
    else
      halt 404, {
        error: "Notification log not found"
      }.to_json
    end
  end
end