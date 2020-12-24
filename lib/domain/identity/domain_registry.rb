class DomainRegistry
  class << self
    def encryption_service
      BCryptEncryptionService
    end

    def password_service
      PasswordService.new
    end

    def authentication_service
      AuthenticationService.new(
        tenant_repository: tenant_repository,
        user_repository: user_repository,
        encryption_service: encryption_service
      )
    end

    def tenant_provision_service
      TenantProvisionService.new(
        tenant_repository: tenant_repository,
        user_repository: user_repository,
        role_repository: role_repository
      )
    end

    def tenant_repository
      @@tenant_repository ||= InMemoryTenantRepository.new
    end

    def user_repository
      @@user_repository ||= InMemoryUserRepository.new
    end

    def role_repository
      @@role_repository ||= InMemoryRoleRepository.new
    end

    def group_repository
      @@group_repository ||= InMemoryGroupRepository.new
    end
  end
end