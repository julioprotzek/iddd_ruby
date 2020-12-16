class DomainEventPublisher
  include Singleton
  attr_reader :subscribers

  def initialize
    reset
  end

  def reset
    @subscribers = {}
    @publishing = false
  end

  def publishing?
    @publishing
  end
  
  def subscribe(domain_event_klass, &handler_block)
    @subscribers[domain_event_klass] ||= []
    @subscribers[domain_event_klass] << handler_block
  end

  def publish(domain_event)
    if @subscribers[domain_event.class]&.any? && !publishing?
      begin
        @publishing = true
        @subscribers[domain_event.class].each do |handler_block|
          handler_block.call(domain_event)
        end
      ensure
        @publishing = false
      end
    end
  end
end