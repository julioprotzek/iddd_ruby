class ApplicationServiceRegistry
  class << self
    def access_application_service
      AccessApplicationService.new(
        group_repository: group_repository,
        role_repository: role_repository,
        tenant_repository: tenant_repository,
        user_repository: user_repository
      )
    end

    private

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
  end
end