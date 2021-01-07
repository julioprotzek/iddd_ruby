require './test/domain/identity_access_test'
require './test/domain/identity/tenant_repository_shared_tests'

class ActiveRecordTenantRepositoryTest < IdentityAccessTest
  extend TenantRepositorySharedTests

  setup do
    # Ensure correct subject under test (ignores IdentityAccessTest stub config)
    DomainRegistry.stubs(:tenant_repository).returns(ActiveRecord::TenantRepository.new)
    DomainRegistry.tenant_repository.clean
  end

  it_behaves_like_a_tenant_repository
end