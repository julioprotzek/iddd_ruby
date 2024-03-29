require './test/test_helper'
require './test/common/testable_domain_event'
require './test/common/another_testable_domain_event'

class DomainEventPublisherTest < ActiveSupport::TestCase
  setup do
    DomainEventPublisher.reset
    @another_event_handled = @event_handled = false
  end

  test 'publish' do
    DomainEventPublisher.subscribe(TestableDomainEvent) do |domain_event|
      assert_equal 123, domain_event.id
      assert_equal 'test', domain_event.name
      @event_handled = true
    end

    assert_equal false, @event_handled

    DomainEventPublisher.publish(TestableDomainEvent.new(id: 123, name: 'test'))

    assert_equal true, @event_handled
  end

  test 'publisher blocked' do
    DomainEventPublisher.subscribe(TestableDomainEvent) do |domain_event|
      assert_equal 123, domain_event.id
      assert_equal 'test', domain_event.name
      @event_handled = true

      # attempt nested publish, which should not work
      DomainEventPublisher.publish(AnotherTestableDomainEvent.new(value: 1000.0))
    end

    DomainEventPublisher.subscribe(AnotherTestableDomainEvent) do |domain_event|
      # should never be reached due to blocked publisher
      assert_equal 1000.0, domain_event.value
      @another_event_handled = true
    end

    assert_equal false, @event_handled
    assert_equal false, @another_event_handled

    DomainEventPublisher.publish(TestableDomainEvent.new(id: 123, name: 'test'))

    assert_equal true, @event_handled
    assert_equal false, @another_event_handled
  end

  test 'handles subscriber exceptions gracefully' do
    assert_equal false, DomainEventPublisher.publishing?

    DomainEventPublisher.subscribe(TestableDomainEvent) do |domain_event|
      raise StandardError.new('Error from domain event subscription block')
    end

    error = assert_raises StandardError do
      DomainEventPublisher.publish(TestableDomainEvent.new(id: 123, name: 'test'))
    end

    assert_equal 'Error from domain event subscription block', error.message

    assert_equal false, DomainEventPublisher.publishing?
  end

  test 'handles multiple subscribers to multiple event types' do
    DomainEventPublisher.reset
    event_handled_count = 0
    another_event_handled_count = 0

    DomainEventPublisher.subscribe(TestableDomainEvent) do |domain_event|
      event_handled_count += 1
    end

    DomainEventPublisher.subscribe(AnotherTestableDomainEvent) do |domain_event|
      another_event_handled_count +=1
    end

    DomainEventPublisher.subscribe(TestableDomainEvent) do |domain_event|
      event_handled_count += 1
    end

    DomainEventPublisher.publish(TestableDomainEvent.new(id: 123, name: 'test'))
    DomainEventPublisher.publish(AnotherTestableDomainEvent.new(value: 1111))

    assert_equal 2, event_handled_count
    assert_equal 1, another_event_handled_count
  end

  test 'reset subscribers' do
    event_handled_count = 0
    another_event_handled_count = 0

    DomainEventPublisher.subscribe(TestableDomainEvent) do |domain_event|
      event_handled_count += 1
    end

    DomainEventPublisher.subscribe(AnotherTestableDomainEvent) do |domain_event|
      another_event_handled_count +=1
    end

    DomainEventPublisher.subscribe(TestableDomainEvent) do |domain_event|
      event_handled_count += 1
    end

    DomainEventPublisher.publish(TestableDomainEvent.new(id: 123, name: 'test'))
    DomainEventPublisher.publish(AnotherTestableDomainEvent.new(value: 1111))

    assert_equal 2, event_handled_count
    assert_equal 1, another_event_handled_count

    DomainEventPublisher.reset

    DomainEventPublisher.publish(TestableDomainEvent.new(id: 123, name: 'test'))
    DomainEventPublisher.publish(AnotherTestableDomainEvent.new(value: 1111))

    assert_equal 2, event_handled_count
    assert_equal 1, another_event_handled_count
  end

  test 'only publishes for the correct subscribers' do
    event_handled = false
    DomainEventPublisher.subscribe(TestableDomainEvent) do |domain_event|
      event_handled = true
    end

    DomainEventPublisher.publish(AnotherTestableDomainEvent.new(value: 1111))
    assert_equal false, event_handled
  end

  test 'handler subscribed to DomainEvent receives all events' do
    event_handled = false
    DomainEventPublisher.subscribe(DomainEvent) do |domain_event|
      event_handled = true
    end

    DomainEventPublisher.publish(TestableDomainEvent.new(id: 123, name: 'test'))
    assert_equal true, event_handled
  end
end