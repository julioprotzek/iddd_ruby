class ActiveRecord::EventStore
  class StoredEventModel < ActiveRecord::Base
    self.table_name = 'stored_events'

    before_create :set_event_id

    def set_event_id
      last_event_id = StoredEventModel.maximum(:event_id)
      self.event_id = last_event_id.to_i + 1
    end
  end

  def all_stored_events_between(low_stored_event_id, high_stored_event_id)
    StoredEventModel
      .where(event_id: low_stored_event_id..high_stored_event_id)
      .map{ |record| as_stored_event(record) }
  end

  def all_stored_events_since(stored_event_id)
    StoredEventModel
      .where('event_id > ?', stored_event_id)
      .map{ |record| as_stored_event(record) }
  end

  def append(domain_event)
    StoredEventModel.create(
      type_name: domain_event.class.name,
      occurred_at: domain_event.occurred_at,
      body: EventSerializer.serialize(domain_event)
    )
  end

  def close
    clean
  end

  def count_stored_events
    StoredEventModel.count
  end

  def clean
    StoredEventModel.delete_all
    nil
  end

  private

  def as_stored_event(record)
    StoredEvent.new(
      type_name: record.type_name,
      occurred_at: record.occurred_at,
      event_body: record.body,
      event_id: record.event_id
    )
  end
end