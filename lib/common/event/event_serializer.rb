class EventSerializer
  class << self
    def serialize(domain_event)
      domain_event.to_json
    end

    def deserialize(event_body, type_name)
      attrs = ActiveSupport::JSON.decode(event_body).symbolize_keys
      version = attrs.delete :version
      occurred_at = attrs.delete :occurred_at

      domain_event = type_name.constantize.new(**attrs)
      domain_event.instance_variable_set(:@version, version.to_i)
      domain_event.instance_variable_set(:@occurred_at, Time.parse(occurred_at))

      domain_event
    end
  end
end
