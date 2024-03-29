require './test/domain/identity_access_test'
require './test/domain/identity/user_repository_shared_tests'

class InMemoryUserRepositoryTest < IdentityAccessTest
  extend UserRepositorySharedTests

  setup do
    # Ensure correct subject under test (ignores IdentityAccessTest stub config)
    DomainRegistry.stubs(:user_repository).returns(InMemory::UserRepository.new)
    DomainRegistry.user_repository.clean
  end

  it_behaves_like_a_user_repository
end