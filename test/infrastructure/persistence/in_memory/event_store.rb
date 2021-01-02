class InMemory::EventStore
  def initialize
    @stored_events = []
  end

  def all_stored_events_between(low_stored_event_id, high_stored_event_id)
    stored_events.select do |stored_event|
      stored_event.event_id >= low_stored_event_id &&
      stored_event.event_id <= high_stored_event_id
    end
  end

  def all_stored_events_since(stored_event_id)
    stored_events.select do |stored_event|
      stored_event.event_id > stored_event_id
    end
  end

  def append(domain_event)
    stored_events << StoredEvent.new(
      type_name: domain_event.class.name,
      occurred_at: domain_event.occurred_at,
      event_body: EventSerializer.serialize(domain_event),
      event_id: stored_events.size + 1
    )
  end

  def close
    clean
  end

  def count_stored_events
    stored_events.size
  end

  def clean
    @stored_events = []
  end

  private

  attr_reader :stored_events
end