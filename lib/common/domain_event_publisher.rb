class DomainEventPublisher
  include Singleton
  
  def initialize
    @subscribers = {}
  end
  
  def subscribe(domain_event_klass, &block)
    @subscribers[domain_event_klass] = block
  end

  def publish(domain_event)
    @subscribers[domain_event.class].call(domain_event)
  end
end