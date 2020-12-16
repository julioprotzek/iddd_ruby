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
      begin
        @publishing = true
        @subscribers[domain_event.class].call(domain_event)        
      ensure
        @publishing = false
      end
    end
  end
end