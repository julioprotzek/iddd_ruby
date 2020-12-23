class DomainRegistry
  def self.encryption_service
    BCryptEncryptionService
  end

  def self.password_service
    PasswordService.new
  end

  def self.tenant_provision_service
    TenantProvisionService.new(tenant_repository: InMemoryTenantRepository.new, user_repository: InMemoryUserRepository.new, role_repository: InMemoryRoleRepository.new)
  end

  def self.tenant_repository
    @tenant_repository ||= InMemoryTenantRepository.new
  end
end