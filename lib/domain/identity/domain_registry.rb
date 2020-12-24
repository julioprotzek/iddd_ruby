class DomainRegistry
  class << self
    def encryption_service
      BCryptEncryptionService
    end

    def password_service
      PasswordService.new
    end

    def tenant_provision_service
      TenantProvisionService.new(tenant_repository: InMemoryTenantRepository.new, user_repository: InMemoryUserRepository.new, role_repository: InMemoryRoleRepository.new)
    end

    def tenant_repository
      @@tenant_repository ||= InMemoryTenantRepository.new
    end

    def user_repository
      @@user_repository ||= InMemoryUserRepository.new
    end
  end
end