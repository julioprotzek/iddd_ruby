class IdentityAccessEventProcessor
  # Registers a IdentityAccessEventProcessor to listen
  # and forward all domain events to external subsribers.
  def self.register
    IdentityAccessEventProcessor.new.listen
  end

  def initialize
    @event_store = EventStore.new
  end

  # Listen for all domain events and and stores them.
  def listen
    DomainEventPublisher.subscribe(DomainEvent) do |domain_event|
      store(domain_event)
    end
  end

  private

  # Stores domain event to the event store
  def store(domain_event)
    event_store.append(domain_event)
  end

  attr_reader :event_store
end