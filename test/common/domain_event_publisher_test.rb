require './test/test_helper'
require './test/common/testable_domain_event'
require './test/common/another_testable_domain_event'

class DomainEventPublisherTest < ActiveSupport::TestCase
  setup do
    DomainEventPublisher.instance.reset
    @another_event_handled = @event_handled = false
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

  test 'publisher blocked' do
    DomainEventPublisher.instance.subscribe(TestableDomainEvent) do |a_domain_event|
      assert_equal 123, a_domain_event.id
      assert_equal 'test', a_domain_event.name
      @event_handled = true

      # attempt nested publish, which should not work
      DomainEventPublisher.instance.publish(AnotherTestableDomainEvent.new(1000.0))
    end

    DomainEventPublisher.instance.subscribe(AnotherTestableDomainEvent) do |a_domain_event|
      # should never be reached due to blocked publisher
      assert_equal 1000.0, a_domain_event.value
      @another_event_handled = true
    end

    assert_equal false, @event_handled
    assert_equal false, @another_event_handled

    DomainEventPublisher.instance.publish(TestableDomainEvent.new(123, 'test'))

    assert_equal true, @event_handled
    assert_equal false, @another_event_handled
  end

  test 'handles subscriber exceptions gracefully' do
    assert_equal false, DomainEventPublisher.instance.publishing?

    DomainEventPublisher.instance.subscribe(TestableDomainEvent) do |a_domain_event|
      raise StandardError.new('Error from domain event subscription block')
    end

    error = assert_raises StandardError do
      DomainEventPublisher.instance.publish(TestableDomainEvent.new(123, 'test'))
    end

    assert_equal 'Error from domain event subscription block', error.message

    assert_equal false, DomainEventPublisher.instance.publishing?
  end

  test 'handles multiple subscribers to multiple event types' do
    DomainEventPublisher.instance.reset
    event_handled_count = 0
    another_event_handled_count = 0

    DomainEventPublisher.instance.subscribe(TestableDomainEvent) do |a_domain_event|
      event_handled_count += 1
    end

    DomainEventPublisher.instance.subscribe(AnotherTestableDomainEvent) do |a_domain_event|
      another_event_handled_count +=1
    end

    DomainEventPublisher.instance.subscribe(TestableDomainEvent) do |a_domain_event|
      event_handled_count += 1
    end

    DomainEventPublisher.instance.publish(TestableDomainEvent.new(123, 'test'))
    DomainEventPublisher.instance.publish(AnotherTestableDomainEvent.new(1111))

    assert_equal 2, event_handled_count
    assert_equal 1, another_event_handled_count
  end

  test 'reset subscribers' do
    event_handled_count = 0
    another_event_handled_count = 0

    DomainEventPublisher.instance.subscribe(TestableDomainEvent) do |a_domain_event|
      event_handled_count += 1
    end

    DomainEventPublisher.instance.subscribe(AnotherTestableDomainEvent) do |a_domain_event|
      another_event_handled_count +=1
    end

    DomainEventPublisher.instance.subscribe(TestableDomainEvent) do |a_domain_event|
      event_handled_count += 1
    end

    DomainEventPublisher.instance.publish(TestableDomainEvent.new(123, 'test'))
    DomainEventPublisher.instance.publish(AnotherTestableDomainEvent.new(1111))

    assert_equal 2, event_handled_count
    assert_equal 1, another_event_handled_count

    DomainEventPublisher.instance.reset

    DomainEventPublisher.instance.publish(TestableDomainEvent.new(123, 'test'))
    DomainEventPublisher.instance.publish(AnotherTestableDomainEvent.new(1111))

    assert_equal 2, event_handled_count
    assert_equal 1, another_event_handled_count
  end

  test 'only publishes for the correct subscribers' do
    event_handled = false
    DomainEventPublisher.instance.subscribe(TestableDomainEvent) do |a_domain_event|
      event_handled = true
    end

    DomainEventPublisher.instance.publish(AnotherTestableDomainEvent.new(1111))
    assert_equal false, event_handled
  end
end