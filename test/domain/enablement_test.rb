require './test/test_helper'

class EnablementTest < ActiveSupport::TestCase
  test 'enabled' do
    enablement = Enablement.new(enabled: true)
    assert enablement.enablement_enabled?
  end

  test 'disabled' do
    enablement = Enablement.new(enabled: false)
    assert !enablement.enablement_enabled?
  end

  test 'disabled before start_at date' do
    enablement = Enablement.new(
      enabled: true, 
      start_at: Date.tomorrow, 
      end_at: Date.tomorrow + 1.day
    )
    assert !enablement.enablement_enabled?
  end

  test 'disabled after end_at date' do
    enablement = Enablement.new(
      enabled: true, 
      start_at: Date.yesterday - 1.day, 
      end_at: Date.yesterday
    )
    assert !enablement.enablement_enabled?
  end

  test 'unsequenced dates' do
    error = assert_raises ArgumentError do
      Enablement.new(
        enabled: true, 
        start_at: Date.tomorrow, 
        end_at: Date.yesterday
      )
    end
  end

  test 'equality' do
    assert_equal Enablement.new(enabled: true), Enablement.new(enabled: true)
    assert_not_equal Enablement.new(enabled: false), Enablement.new(enabled: true)

    assert_equal Enablement.new(
      enabled: true, 
      start_at: Date.yesterday, 
      end_at: Date.tomorrow
    ), Enablement.new(
      enabled: true, 
      start_at: Date.yesterday, 
      end_at: Date.tomorrow
    )

    assert_not_equal Enablement.new(
      enabled: true, 
      start_at: Date.yesterday, 
      end_at: Date.tomorrow + 1.day
    ), Enablement.new(
      enabled: true, 
      start_at: Date.yesterday, 
      end_at: Date.tomorrow
    )
  end
end