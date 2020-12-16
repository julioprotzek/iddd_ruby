class DomainEventPublisher
  include Singleton
  
  def initialize
    @subscribers = {}
    @publishing = false
  end

  def publishing?
    @publishing
  end
  
  def subscribe(domain_event_klass, &block)
    @subscribers[domain_event_klass] = block
  end

  def publish(domain_event)
    unless publishing?
      @publishing = true
      @subscribers[domain_event.class].call(domain_event)
      @publishing = false
    end
  end
end