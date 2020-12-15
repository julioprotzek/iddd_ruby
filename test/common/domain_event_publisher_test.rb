require './test/test_helper'

class TestableDomainEvent
  attr_reader :id, :name

  def initialize(an_id, a_name)
    @id = an_id
    @name = a_name
  end
end

class DomainEventPublisherTest < ActiveSupport::TestCase
  setup do
    @event_handled = false
  end

  test 'publish' do
    DomainEventPublisher.instance.subscribe(TestableDomainEvent) do |a_domain_event|
      assert_equal 123, a_domain_event.id
      assert_equal 'test', a_domain_event.name
      @event_handled = true
    end

    assert_equal false, @event_handled

    DomainEventPublisher.instance.publish(TestableDomainEvent.new(123, 'test'))

    assert_equal true, @event_handled
  end
end