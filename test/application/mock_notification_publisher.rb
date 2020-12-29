class MockNotificationPublisher
  def publish_notifications
    @confirmed = true
  end

  def internal_only_test_confirmation
    @confirmed
  end
end