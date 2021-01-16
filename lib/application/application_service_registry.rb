class ApplicationServiceRegistry
  class << self
    def access_application_service
      AccessApplicationService.new(
        group_repository: group_repository,
        role_repository: role_repository,
        tenant_repository: tenant_repository,
        user_repository: user_repository,
        group_member_service: group_member_service,
      )
    end

    def identity_application_service
      IdentityApplicationService.new(
        group_repository: group_repository,
        tenant_repository: tenant_repository,
        user_repository: user_repository
      )
    end

    def notification_application_service
      NotificationApplicationService.new(event_store, notification_publisher)
    end

    def event_store
      @@event_store ||= ActiveRecord::EventStore.new
    end

    def notification_publisher
      @@notification_publisher ||= RabbitMQ::NotifiationPublisher.new(
        event_store,
        published_notification_tracker_store,
        'identity_access'
      )
    end

    private

    def published_notification_tracker_store
      ActiveRecord::PublishedNotificationTrackerStore.new
    end

    def tenant_repository
      DomainRegistry.tenant_repository
    end

    def user_repository
      DomainRegistry.user_repository
    end

    def role_repository
      DomainRegistry.role_repository
    end

    def group_repository
      DomainRegistry.group_repository
    end

    def group_member_service
      DomainRegistry.group_member_service
    end
  end
end