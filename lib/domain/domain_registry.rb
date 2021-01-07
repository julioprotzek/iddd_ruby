class DomainRegistry
  class << self
    def authentication_service
      AuthenticationService.new(
        tenant_repository: tenant_repository,
        user_repository: user_repository,
        encryption_service: encryption_service
      )
    end

    def authorization_service
      AuthorizationService.new(
        user_repository: user_repository,
        group_repository: group_repository,
        role_repository: role_repository
      )
    end

    def encryption_service
      BCryptEncryptionService
    end

    def password_service
      PasswordService.new
    end

    def tenant_provision_service
      TenantProvisionService.new(
        tenant_repository: tenant_repository,
        user_repository: user_repository,
        role_repository: role_repository
      )
    end

    def group_member_service
      GroupMemberService.new(
        group_repository: group_repository,
        user_repository: user_repository
      )
    end

    def tenant_repository
      @@tenant_repository ||= ActiveRecord::TenantRepository.new
    end

    def user_repository
      @@user_repository ||= ActiveRecord::UserRepository.new
    end

    def role_repository
      # TODO Implement ActiveRecord Repository
      # @@role_repository ||= ActiveRecord::RoleRepository.new
      @@role_repository ||= InMemory::RoleRepository.new
    end

    def group_repository
      @@group_repository ||= ActiveRecord::GroupRepository.new
    end
  end
end