class NotificationSerializer
  class << self
    def serialize(notification)
      notification.to_json
    end

    def deserialize(event_body, type_name)
      domain_event = EventSerializer.deserialize(event_body, type_name)
      Notification.new(domain_event.id, domain_event)
    end
  end
end
