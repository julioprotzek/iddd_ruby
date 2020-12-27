class EventSerializer
  class << self
    def serialize(domain_event)
      domain_event.to_json
    end

    def deserialize(event_body, type_name)
      attrs = ActiveSupport::JSON.decode(event_body)
      type_name.constantize.new(*attrs)
    end
  end
end
